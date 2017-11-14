  class CategoriesController < ApplicationController
    helper 'forem/forums'
    load_and_authorize_resource :class => 'Category'
  end
