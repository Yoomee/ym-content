class PostsController < ApplicationController
  include YmPosts::PostsController

  private
  def permitted_post_parameters
    %w(file image retained_file retained_image tag_list target_id target_type text video_url)
  end
end