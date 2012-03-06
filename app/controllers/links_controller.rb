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
    p params[:type]
    unless request.xhr?
      respond_to do |format|
        if @link = @user.create_association(params[:link])
          format.html { redirect_to @link, notice: 'Link was successfully created.' }
          format.json { render json: @link, status: :created, location: @link }
        else
          format.html { render action: "new" }
          format.json { render json: @link.errors, status: :unprocessable_entity }
        end
      end
    else
      if @link = @user.create_association(params[:link])
        render :partial => 'a_link', :locals=>{:link=>@link, :type=>params[:type]}
      else
        link_params = params[:link]
        link_params.delete(:value)
        blank_link = Link.new(link_params)
        render :partial => 'a_link', :locals=>{:link=>blank_link, :type=>params[:type]}
      end
    end
  end

  # PUT /links/1
  # PUT /links/1.json
  def update
    p params[:type]
    @previous_link = Link.find(params[:id])
    unless request.xhr?
      respond_to do |format|
        if @link = @user.update_association(@previous_link, params[:link])
          format.html { redirect_to @link, notice: 'Link was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @previous_link.errors, status: :unprocessable_entity }
        end
      end
    else
      if @link = @user.update_association(@previous_link, params[:link])
        render :partial => 'a_link', :locals=>{:link=>@link, :type=>params[:type]}
      else
        render :partial => 'a_link', :locals=>{:link=>@previous_link, :type=>params[:type]}
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    p params[:type]
    old_link = Link.find(params[:id])
    removed = UserLink.where(:user_id=>@user.id, :link_id=>old_link.id)[0].try(:destroy) 
    #trigger cache updates
    old_link.save!
    unless request.xhr?
      respond_to do |format|
        format.html { redirect_to links_url }
        format.json { head :ok }
      end
    else
      link_params = params[:link]
      link_params.delete(:value)
      blank_link = Link.new(link_params)
      render :partial => 'a_link', :locals=>{:link=>blank_link, :type=>params[:type]}
    end
  end
end
