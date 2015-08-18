{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes        #-}

-- Module      : Gen.Protocol
-- Copyright   : (c) 2013-2015 Brendan Hay
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : provisional
-- Portability : non-portable (GHC extensions)

module Gen.Protocol
    ( Names(..)
    , memberName
    , nestedNames
    , suffix
    ) where

import           Control.Applicative
import           Control.Comonad.Cofree
import           Control.Lens
import           Data.Maybe
import           Data.Text              (Text)
import           Data.Text.Manipulate
import           Gen.Types

suffix :: Protocol -> Text
suffix = \case
    JSON     -> "JSON"
    RestJSON -> "JSON"
    RestXML  -> "XML"
    Query    -> "XML"
    EC2      -> "XML"

data Names
    = NMap  (Maybe Text) Text Text Text
    | NList (Maybe Text) Text
    | NName Text
      deriving (Show)

memberName :: Protocol -> Direction -> Id -> RefF (Shape a) -> Text
memberName p d n r =
    case nestedNames p d n r of
        NMap  mn e _ _ -> fromMaybe e mn
        NList mn i     -> fromMaybe i mn
        NName x        -> x

nestedNames :: Protocol -> Direction -> Id -> RefF (Shape a) -> Names
nestedNames p d n r =
    case unwrap (r ^. refAnn) of
        Map  m -> mapNames  p d n r m
        List l -> listNames p d n r l
        _      -> NName (name p d n r)

listNames :: Protocol -> Direction -> Id -> RefF a -> ListF a -> Names
listNames p d n r l
     | flatten p d l = NList Nothing   rn
     | otherwise     = NList (Just mn) (fromMaybe "member" ln)
  where
    -- Flattened member names
    rn | p == EC2,   d == Input = upperHead (fromMaybe mn qrn)
       | p == Query, d == Input = fromMaybe mn ln
       | otherwise              = fromMaybe mn ln
      where
        qrn = r ^. refQueryName <|> r ^. refLocationName

    -- Non-flattened member name
    ln = l ^. listItem . refLocationName

    mn = name p d n r

     -- Member, [item]

     -- Non-flattened, no locationName:
     -- <ListParam><member>one</member><member>two</member><member>...

     -- Non-flattened, alternate memberName and itemName:
     -- <AlternateName><NotMember>one</NotMember><NotMember>...

     -- [Member]

     -- Flattened, no locationName:
     -- <ListParam>one</ListParam><ListParam>two</ListParam>...

mapNames :: Protocol -> Direction -> Id -> RefF a -> MapF a -> Names
mapNames p d n r m
    | flatten p d m = NMap Nothing   mn      kn vn
    | otherwise     = NMap (Just mn) "entry" kn vn
  where
    mn = name p d n r
    kn = fromMaybe "key"   (m ^. mapKey   . refLocationName)
    vn = fromMaybe "value" (m ^. mapValue . refLocationName)

    -- Member, [entry, key, value]

    -- Non-flattened, no locationNames:
    -- <Map><entry><key>qux</key><value><foo>bar</foo></value></entry></Map>

    -- Non-flattened, locationNames:
    -- <Map><entry><foo>qux</foo><bar>bar</bar></entry></Map>

    -- Nothing, [Member, key, value]

    -- Flattened, no locationNames:
    -- <Map><key>qux</key><value>bar</value></Map><Map><key>baz</key><value>bam</value></Map>

    -- Flattened, locationNames:
    -- <Map><foo>qux</foo><bar>qux</var></Map>

    -- Query, input:
    -- MapArg.entry.1.key=key1&MapArg.entry.1.value=val1

-- FIXME: Go through the other SDK's tests to ensure correctness.
name :: Protocol -> Direction -> Id -> RefF a -> Text
name p d n r = go p d
  where
    go EC2 Input = upperHead $ fromMaybe key (r ^. refQueryName)
    go _   _     = key

    -- Use the locationName on the struct member if present,
    -- otherwise the struct member id.
    key = fromMaybe (memberId n) (r ^. refLocationName)

flatten :: HasInfo a => Protocol -> Direction -> a -> Bool
flatten EC2 Input _ = True
flatten _   _     i = i ^. infoFlattened
