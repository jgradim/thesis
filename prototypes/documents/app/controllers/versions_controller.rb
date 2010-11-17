class VersionsController < ApplicationController
  # GET /versions
  # GET /versions.xml
  def index
    @versions = Version.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @versions }
    end
  end

  # GET /versions/1
  # GET /versions/1.xml
  def show
    @version = Version.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @version }
    end
  end

  # GET /versions/new
  # GET /versions/new.xml
  def new
    @version = Version.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @version }
    end
  end

  # GET /versions/1/edit
  def edit
    @version = Version.find(params[:id])
  end

  # POST /versions
  # POST /versions.xml
  def create
    @version = Version.new(params[:version])

    respond_to do |format|
      if @version.save
        format.html { redirect_to(@version, :notice => 'Version was successfully created.') }
        format.xml  { render :xml => @version, :status => :created, :location => @version }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @version.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /versions/1
  # PUT /versions/1.xml
  def update
    @version = Version.find(params[:id])

    respond_to do |format|
      if @version.update_attributes(params[:version])
        format.html { redirect_to(@version, :notice => 'Version was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @version.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /versions/1
  # DELETE /versions/1.xml
  def destroy
    @version = Version.find(params[:id])
    @version.destroy

    respond_to do |format|
      format.html { redirect_to(versions_url) }
      format.xml  { head :ok }
    end
  end
end
