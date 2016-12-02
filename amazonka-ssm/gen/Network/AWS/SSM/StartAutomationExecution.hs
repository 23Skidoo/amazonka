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
-- Module      : Network.AWS.SSM.StartAutomationExecution
-- Copyright   : (c) 2013-2016 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : auto-generated
-- Portability : non-portable (GHC extensions)
--
-- Initiates execution of an Automation document.
--
--
module Network.AWS.SSM.StartAutomationExecution
    (
    -- * Creating a Request
      startAutomationExecution
    , StartAutomationExecution
    -- * Request Lenses
    , saeParameters
    , saeDocumentVersion
    , saeDocumentName

    -- * Destructuring the Response
    , startAutomationExecutionResponse
    , StartAutomationExecutionResponse
    -- * Response Lenses
    , srsAutomationExecutionId
    , srsResponseStatus
    ) where

import           Network.AWS.Lens
import           Network.AWS.Prelude
import           Network.AWS.Request
import           Network.AWS.Response
import           Network.AWS.SSM.Types
import           Network.AWS.SSM.Types.Product

-- | /See:/ 'startAutomationExecution' smart constructor.
data StartAutomationExecution = StartAutomationExecution'
    { _saeParameters      :: !(Maybe (Map Text [Text]))
    , _saeDocumentVersion :: !(Maybe Text)
    , _saeDocumentName    :: !Text
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | Creates a value of 'StartAutomationExecution' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'saeParameters' - A key-value map of execution parameters, which match the declared parameters in the Automation document.
--
-- * 'saeDocumentVersion' - The version of the Automation document to use for this execution.
--
-- * 'saeDocumentName' - The name of the Automation document to use for this execution.
startAutomationExecution
    :: Text -- ^ 'saeDocumentName'
    -> StartAutomationExecution
startAutomationExecution pDocumentName_ =
    StartAutomationExecution'
    { _saeParameters = Nothing
    , _saeDocumentVersion = Nothing
    , _saeDocumentName = pDocumentName_
    }

-- | A key-value map of execution parameters, which match the declared parameters in the Automation document.
saeParameters :: Lens' StartAutomationExecution (HashMap Text [Text])
saeParameters = lens _saeParameters (\ s a -> s{_saeParameters = a}) . _Default . _Map;

-- | The version of the Automation document to use for this execution.
saeDocumentVersion :: Lens' StartAutomationExecution (Maybe Text)
saeDocumentVersion = lens _saeDocumentVersion (\ s a -> s{_saeDocumentVersion = a});

-- | The name of the Automation document to use for this execution.
saeDocumentName :: Lens' StartAutomationExecution Text
saeDocumentName = lens _saeDocumentName (\ s a -> s{_saeDocumentName = a});

instance AWSRequest StartAutomationExecution where
        type Rs StartAutomationExecution =
             StartAutomationExecutionResponse
        request = postJSON ssm
        response
          = receiveJSON
              (\ s h x ->
                 StartAutomationExecutionResponse' <$>
                   (x .?> "AutomationExecutionId") <*>
                     (pure (fromEnum s)))

instance Hashable StartAutomationExecution

instance NFData StartAutomationExecution

instance ToHeaders StartAutomationExecution where
        toHeaders
          = const
              (mconcat
                 ["X-Amz-Target" =#
                    ("AmazonSSM.StartAutomationExecution" :: ByteString),
                  "Content-Type" =#
                    ("application/x-amz-json-1.1" :: ByteString)])

instance ToJSON StartAutomationExecution where
        toJSON StartAutomationExecution'{..}
          = object
              (catMaybes
                 [("Parameters" .=) <$> _saeParameters,
                  ("DocumentVersion" .=) <$> _saeDocumentVersion,
                  Just ("DocumentName" .= _saeDocumentName)])

instance ToPath StartAutomationExecution where
        toPath = const "/"

instance ToQuery StartAutomationExecution where
        toQuery = const mempty

-- | /See:/ 'startAutomationExecutionResponse' smart constructor.
data StartAutomationExecutionResponse = StartAutomationExecutionResponse'
    { _srsAutomationExecutionId :: !(Maybe Text)
    , _srsResponseStatus        :: !Int
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | Creates a value of 'StartAutomationExecutionResponse' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'srsAutomationExecutionId' - The unique ID of a newly scheduled automation execution.
--
-- * 'srsResponseStatus' - -- | The response status code.
startAutomationExecutionResponse
    :: Int -- ^ 'srsResponseStatus'
    -> StartAutomationExecutionResponse
startAutomationExecutionResponse pResponseStatus_ =
    StartAutomationExecutionResponse'
    { _srsAutomationExecutionId = Nothing
    , _srsResponseStatus = pResponseStatus_
    }

-- | The unique ID of a newly scheduled automation execution.
srsAutomationExecutionId :: Lens' StartAutomationExecutionResponse (Maybe Text)
srsAutomationExecutionId = lens _srsAutomationExecutionId (\ s a -> s{_srsAutomationExecutionId = a});

-- | -- | The response status code.
srsResponseStatus :: Lens' StartAutomationExecutionResponse Int
srsResponseStatus = lens _srsResponseStatus (\ s a -> s{_srsResponseStatus = a});

instance NFData StartAutomationExecutionResponse
