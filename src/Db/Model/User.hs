{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE InstanceSigs #-}
{-# LANGUAGE OverloadedLists #-}
{-# LANGUAGE OverloadedStrings #-}

module Db.Model.User (User (User)) where

import Control.Lens hiding ((.=))
import Data.Aeson
import Data.Data
import Data.OpenApi
import Data.Text (Text)
import Database.PostgreSQL.Simple
import GHC.Generics (Generic)
import Prelude hiding (id)

data User = User
  { id :: !Int
  , username :: !Text
  , passwordHash :: !Text
  }
  deriving (Show, Eq, Generic)

instance ToJSON User where
  toJSON :: User -> Value
  toJSON user = object ["id" .= id user, "username" .= username user]

instance FromRow User

instance ToSchema User where
  declareNamedSchema _ = do
    intSchema <- declareSchemaRef (Proxy :: Proxy Int)
    textSchema <- declareSchemaRef (Proxy :: Proxy Text)
    return $
      NamedSchema (Just "User") $
        mempty
          & type_ ?~ OpenApiObject
          & properties .~ [("id", intSchema), ("username", textSchema)]
          & required .~ ["id", "username"]
