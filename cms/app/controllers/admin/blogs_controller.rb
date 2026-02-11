class Admin::BlogsController < ApplicationController
  before_action :set_blog, only: %i[show edit update destroy]

  def index
    @blogs = Blog.includes(:tags).order(published_at: :desc)
  end

  def show
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = Blog.new(blog_params)
    assign_tags

    if @blog.save
      redirect_to admin_blog_path(@blog), notice: "ブログを作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @blog.assign_attributes(blog_params)
    assign_tags

    if @blog.save
      redirect_to admin_blog_path(@blog), notice: "ブログを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @blog.destroy!
    redirect_to admin_blogs_path, notice: "ブログを削除しました。"
  end

  private

  def set_blog
    @blog = Blog.find(params[:id])
  end

  def assign_tags
    return unless params[:blog][:tag_names]

    tag_names = params[:blog][:tag_names].split(",").map(&:strip).reject(&:empty?)
    @blog.tags = tag_names.map { |name| Tag.find_or_create_by(name: name) }
  end

  def blog_params
    params.require(:blog).permit(:title, :description, :content, :author, :published_at, :header_image)
  end
end
