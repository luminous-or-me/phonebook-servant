{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Api.Users (UsersAPI, usersServer) where

import Control.Monad.IO.Class (MonadIO (liftIO))
import qualified Data.Text as T
import Database.PostgreSQL.Simple
import Db.Model.User
import Db.Operations
import qualified Dto.NewUser as NU
import Servant

type GetAllUsers = Summary "Get all users" :> Get '[JSON] [User]
type CreateUser =
  Summary "Create a new user"
    :> ReqBody'
        '[Required, Description "The username and password of the person"]
        '[JSON]
        NU.NewUser
    :> PostCreated '[JSON] User
type DeleteUser =
  Summary "Delete user with the given ID"
    :> Capture "id" Int
    :> DeleteNoContent

type UsersAPI = "users" :> (GetAllUsers :<|> CreateUser :<|> DeleteUser)

usersServer :: Connection -> Server UsersAPI
usersServer conn = getAllUsers :<|> createUser :<|> removeUser
 where
  getAllUsers :: Handler [User]
  getAllUsers = liftIO $ allUsers conn

  createUser :: NU.NewUser -> Handler User
  createUser nu =
    if T.null (NU.password nu)
      then throwError err400{errBody = "Empty password!"}
      else liftIO $ insertUser conn nu

  removeUser :: Int -> Handler NoContent
  removeUser userId = do
    liftIO $ deleteUser conn userId
    return NoContent
