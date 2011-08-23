class BlocksController < ApplicationController

  def create
    @document = Document.find(params[:document_id])
    Block.make(params)
    respond_to do |format|
      format.html { redirect_to @document }
      format.js   #{ render :action => :create }
    end
  end

  def update
    @block = Block.find(params[:id])
    @block.build_item(params[:block])
    @block.save

    #redirect_to @block.document
    respond_to do |format|
      format.html { redirect_to @block.document }
      format.js   #{ render :action => :edit }
    end
  end

  def destroy
    @document = Document.find(params[:document_id])
    @block = Block.find(params[:id])
    @block.destroy # needs to be @block.destroy, delete won't call callbacks
    redirect_to @document
  end

end
