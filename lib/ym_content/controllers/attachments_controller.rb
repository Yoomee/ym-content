module YmContent::AttachmentsController
  def create
  	# TODO: Look at how we would deploy this to prod - does it integrate with amazon/fog or do we need extra steps?
    stimg = SirTrevorImage.create(image: params[:attachment][:file]) 
    render json: { file: { url: stimg.image.url } }, status: 200
  end
end