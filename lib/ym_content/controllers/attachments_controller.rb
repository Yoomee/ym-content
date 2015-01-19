module YmContent::AttachmentsController
  def create
  	# TODO: Look at how we would deploy this to prod - does it integrate with amazon/fog or do we need extra steps?
    begin
      stimg = SirTrevorImage.create(image: params[:attachment][:file]) 
      render json: { file: { url: stimg.image.url } }, status: 200
    rescue
      render json: { error: 'Upload failed' }, status: 500
    end
  end
end