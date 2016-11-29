{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE RecordWildCards    #-}
{-# LANGUAGE TypeFamilies       #-}

{-# OPTIONS_GHC -fno-warn-unused-imports #-}
{-# OPTIONS_GHC -fno-warn-unused-binds   #-}
{-# OPTIONS_GHC -fno-warn-unused-matches #-}

-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- |
-- Module      : Network.AWS.APIGateway.CreateRestAPI
-- Copyright   : (c) 2013-2016 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : auto-generated
-- Portability : non-portable (GHC extensions)
--
-- Creates a new 'RestApi' resource.
--
--
module Network.AWS.APIGateway.CreateRestAPI
    (
    -- * Creating a Request
      createRestAPI
    , CreateRestAPI
    -- * Request Lenses
    , craBinaryMediaTypes
    , craCloneFrom
    , craDescription
    , craName

    -- * Destructuring the Response
    , restAPI
    , RestAPI
    -- * Response Lenses
    , raBinaryMediaTypes
    , raWarnings
    , raCreatedDate
    , raName
    , raId
    , raDescription
    ) where

import           Network.AWS.APIGateway.Types
import           Network.AWS.APIGateway.Types.Product
import           Network.AWS.Lens
import           Network.AWS.Prelude
import           Network.AWS.Request
import           Network.AWS.Response

-- | The POST Request to add a new 'RestApi' resource to your collection.
--
--
--
-- /See:/ 'createRestAPI' smart constructor.
data CreateRestAPI = CreateRestAPI'
    { _craBinaryMediaTypes :: !(Maybe [Text])
    , _craCloneFrom        :: !(Maybe Text)
    , _craDescription      :: !(Maybe Text)
    , _craName             :: !Text
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | Creates a value of 'CreateRestAPI' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'craBinaryMediaTypes' - The list of binary media types supported by the 'RestApi' . By default, the 'RestApi' supports only UTF-8-encoded text payloads.
--
-- * 'craCloneFrom' - The ID of the 'RestApi' that you want to clone from.
--
-- * 'craDescription' - The description of the 'RestApi' .
--
-- * 'craName' - The name of the 'RestApi' .
createRestAPI
    :: Text -- ^ 'craName'
    -> CreateRestAPI
createRestAPI pName_ =
    CreateRestAPI'
    { _craBinaryMediaTypes = Nothing
    , _craCloneFrom = Nothing
    , _craDescription = Nothing
    , _craName = pName_
    }

-- | The list of binary media types supported by the 'RestApi' . By default, the 'RestApi' supports only UTF-8-encoded text payloads.
craBinaryMediaTypes :: Lens' CreateRestAPI [Text]
craBinaryMediaTypes = lens _craBinaryMediaTypes (\ s a -> s{_craBinaryMediaTypes = a}) . _Default . _Coerce;

-- | The ID of the 'RestApi' that you want to clone from.
craCloneFrom :: Lens' CreateRestAPI (Maybe Text)
craCloneFrom = lens _craCloneFrom (\ s a -> s{_craCloneFrom = a});

-- | The description of the 'RestApi' .
craDescription :: Lens' CreateRestAPI (Maybe Text)
craDescription = lens _craDescription (\ s a -> s{_craDescription = a});

-- | The name of the 'RestApi' .
craName :: Lens' CreateRestAPI Text
craName = lens _craName (\ s a -> s{_craName = a});

instance AWSRequest CreateRestAPI where
        type Rs CreateRestAPI = RestAPI
        request = postJSON apiGateway
        response = receiveJSON (\ s h x -> eitherParseJSON x)

instance Hashable CreateRestAPI

instance NFData CreateRestAPI

instance ToHeaders CreateRestAPI where
        toHeaders
          = const
              (mconcat
                 ["Accept" =# ("application/json" :: ByteString)])

instance ToJSON CreateRestAPI where
        toJSON CreateRestAPI'{..}
          = object
              (catMaybes
                 [("binaryMediaTypes" .=) <$> _craBinaryMediaTypes,
                  ("cloneFrom" .=) <$> _craCloneFrom,
                  ("description" .=) <$> _craDescription,
                  Just ("name" .= _craName)])

instance ToPath CreateRestAPI where
        toPath = const "/restapis"

instance ToQuery CreateRestAPI where
        toQuery = const mempty
