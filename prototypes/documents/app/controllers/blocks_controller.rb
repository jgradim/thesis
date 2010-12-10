class BlocksController < ApplicationController

  # POST /blocks
  # POST /blocks.xml
  def create
    @block = Block.new(params[:block])
    
    @block.item = params[:block][:type].classify.constantize.new(params[:block][:params])
    @block.save
    
    redirect_to @block.document

    #respond_to do |format|
    #  if @block.save
    #    format.html { redirect_to(@block, :notice => 'Block was successfully created.') }
    #    format.xml  { render :xml => @block, :status => :created, :location => @block }
    #  else
    #    format.html { render :action => "new" }
    #    format.xml  { render :xml => @block.errors, :status => :unprocessable_entity }
    #  end
    #end
  end

  # PUT /blocks/1
  # PUT /blocks/1.xml
  def update
    @block = Block.find(params[:id])
    
    @block.item = params[:block][:type].classify.constantize.new(params[:block][:params])
    @block.save
    
    redirect_to @block.document

    #respond_to do |format|
    #  if @block.update_attributes(params[:block])
    #    format.html { redirect_to(@block, :notice => 'Block was successfully updated.') }
    #    format.xml  { head :ok }
    #  else
    #    format.html { render :action => "edit" }
    #    format.xml  { render :xml => @block.errors, :status => :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /blocks/1
  # DELETE /blocks/1.xml
  def destroy
    @block = Block.find(params[:id])
    @block.destroy # needs to be @block.destroy, delete won't call callbacks

    respond_to do |format|
      format.html { redirect_to(blocks_url) }
      format.xml  { head :ok }
    end
  end
end
