class LinksController < ApplicationController
  before_filter :signed_in_user, :except => [:show, :index]

  def link_ins_edit 
    @links= Link.all 
    if request.xhr?
      render :link_ins_edit, :layout => false
    else
      # renders link_ins_edit
    end
  end
  def link_ins_show
    @links= Link.all 
    if request.xhr?
      render :link_ins_show, :layout => false
    else
      # renders link_ins_show
    end
  end
  def link_tos_edit 
    @links= Link.all 
    if request.xhr?
      render :link_tos_edit, :layout => false
    else
      # renders link_tos_edit
    end
  end
  def link_tos_show
    @links= Link.all 
    if request.xhr?
      render :link_tos_show, :layout => false
    else
      # renders link_tos_show
    end
  end# GET /links
  # GET /links.json
  def index
    @links = Link.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @links }
    end
  end

  # GET /links/1
  # GET /links/1.json
  def show
    @link = Link.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @link }
    end
  end

  # GET /links/new
  # GET /links/new.json
  def new
    @link = Link.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @link }
    end
  end

  # GET /links/1/edit
  def edit
    @link = Link.find(params[:id])
  end

  # POST /links
  # POST /links.json
  def create
    @link = Link.new(params[:link])

    respond_to do |format|
      if @link.save
        format.html { redirect_to @link, notice: 'Link was successfully created.' }
        format.json { render json: @link, status: :created, location: @link }
      else
        format.html { render action: "new" }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /links/1
  # PUT /links/1.json
  def update
    @previous_link = Link.find(params[:id])
    @link = Link.find_or_initialise_by_node_from_and_node_to_and_value(params[:link][:node_from], params[:link][:node_to], params[:link][:value])
    unless request.xhr?
      respond_to do |format|
        if @link.update_attributes(params[:link])
          format.html { redirect_to @link, notice: 'Link was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @link.errors, status: :unprocessable_entity }
        end
      end
    else    
      if @link.update_attributes(params[:link])
        render :partial => 'a_link', :locals=>{:link=>@link}
      else
        
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link = Link.find(params[:id])
    @link.destroy

    respond_to do |format|
      format.html { redirect_to links_url }
      format.json { head :ok }
    end
  end
end
