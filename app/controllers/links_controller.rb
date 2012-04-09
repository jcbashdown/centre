class LinksController < ApplicationController
  before_filter :signed_in_user, :except => [:show, :index]
  before_filter :find_limit_order, :except => [:show, :index, :edit, :new]

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
    @glu = GlobalLinkUser.new(params[:link].merge(:global => @question, :user => @user))
    respond_to do |format|
      if @glu.save
        format.js { render :partial => 'a_link', :locals=>{:link=>@glu, :type=>params[:type]} }
        format.html { redirect_to @glu, notice: 'Link was successfully created.' }
        format.json { render json: @glu, status: :created, location: @glu }
      else
        link_params = params[:link]
        link_params.delete(:value)
        blank_link = GlobalLinkUser.new(link_params)
        format.js { render :partial => 'a_link', :locals=>{:link=>blank_link, :type=>params[:type]} }
        format.html { render action: "new" }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /links/1
  # PUT /links/1.json
  def update
    node_from = params[:link][:node_from_id]
    nodes_global_from = NodesGlobal.where(:global_id=>@question.id, :node_id=>node_from)[0] || NodesGlobal.create(:global=>@question, :node_id=>node_from)
    node_to = params[:link][:node_to_id]
    nodes_global_to = NodesGlobal.where(:global_id=>@question.id, :node_id=>node_to)[0] || NodesGlobal.create(:global=>@question, :node_id=>node_to)
    link_params = params[:link].merge(:nodes_global_from_id=>nodes_global_from.id,:nodes_global_to_id=>nodes_global_to.id)
    @previous_link = Link.find(params[:id])
    unless request.xhr?
      respond_to do |format|
        if @link = @user.update_association(@previous_link, link_params)
          format.html { redirect_to @link, notice: 'Link was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @previous_link.errors, status: :unprocessable_entity }
        end
      end
    else
      if @link = @user.update_association(@previous_link, link_params)
        render :partial => 'a_link', :locals=>{:link=>@link, :type=>params[:type]}
      else
        render :partial => 'a_link', :locals=>{:link=>@previous_link, :type=>params[:type]}
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
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
