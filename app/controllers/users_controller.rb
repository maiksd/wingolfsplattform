# -*- coding: utf-8 -*-
class UsersController < ApplicationController

  before_filter :find_user, :except => [ :index, :new, :create ]

  def index
    @users = User.all
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      #format.json { render json: @profile.sections }  # TODO
    end
  end

  def new
    @title = t :create_user
    @user = User.new
    @user.alias = params[:alias]
    
  end

  def create
    @user = User.new( params[:user] )
    if @user.save
      redirect_to :action => "show", :alias => @user.alias
    else
      @title = t :create_user
      @user.valid?
      render :action => "new"
    end
  end

  private

  def find_user
    @alias = params[ :alias ]
    id = params[ :id ]
    if @alias
      @user = User.find_by_alias( @alias ) #User.find( :first, :conditions => "alias='#{@alias}'" )
    elsif id
      @user = User.find_by_id( id )
    else
      @user = User.new
    end
    if @user
      @navable = @user
      @title = @user.title
    else
      @title = t :user_not_found
      @title += ": #{@alias}" if @alias
    end
  end

end
