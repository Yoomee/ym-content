class UsersController < ApplicationController
  include YmUsers::UsersController
  load_and_authorize_resource
end