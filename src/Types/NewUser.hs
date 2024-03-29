{-# LANGUAGE DeriveGeneric #-}

module Types.NewUser (NewUser (..)) where

import Data.Aeson (FromJSON, ToJSON)
import Data.Swagger (ToSchema)
import Data.Text (Text)
import Database.PostgreSQL.Simple (ToRow)
import GHC.Generics (Generic)

data NewUser = NewUser
  { username :: !Text
  , password :: !Text
  }
  deriving (Show, Eq, Generic)

instance ToRow NewUser
instance FromJSON NewUser
instance ToJSON NewUser
instance ToSchema NewUser
