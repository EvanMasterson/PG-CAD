require 'observer'
class UploadedFilesController < ApplicationController
  include Observable
  before_action :observer, only: [:share_file]
  before_action :get_storage, except: [:download_shared_file, :share_file]
  before_action :set_uploaded_file, only: [:show, :edit, :update, :destroy]

  # GET /uploaded_files
  # GET /uploaded_files.json
  def index
    if !@storage.nil?
      @uploaded_files = @storage.uploaded_files
    else
      flash[:error] = "Storages or Files do not exist, or you do not have permission to access"
      redirect_to root_path
    end
  end

  # GET /uploaded_files/1
  # GET /uploaded_files/1.json
  def show
    if @uploaded_file.nil?
      flash[:error] = "File does not exist, or you do not have permission to access"
      redirect_to root_path
    end
  end

  # GET /uploaded_files/new
  def new
    @uploaded_file = @storage.uploaded_files.build
  end

  # GET /uploaded_files/1/edit
  def edit
  end

  # POST /uploaded_files
  # POST /uploaded_files.json
  def create
    @uploaded_file = @storage.uploaded_files.build(uploaded_file_params)
    @uploaded_file.set_self

    name = params[:uploaded_file][:image].original_filename
    size = :image.size

    respond_to do |format|
      if RailsValidator.validate_file( name, size) && @uploaded_file.save
        update_storage_size

        format.html { redirect_to storage_uploaded_files_path(@storage), notice: 'Uploaded file was successfully created.' }
        format.json { render :show, status: :created, location: @uploaded_file }
      else
        flash[:error] = "Invalid file format"
        format.html { render :new }
        format.json { render json: @uploaded_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploaded_files/1
  # DELETE /uploaded_files/1.json
  def destroy
    @uploaded_file.destroy
    respond_to do |format|
      update_storage_size
      
      format.html { redirect_to storage_uploaded_files_path(@storage), notice: 'Uploaded file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def download_file
    set_uploaded_file
    file = @uploaded_file.image

    if file.try(:file).exists?
      data = open(file.url)
      send_data data.read, type: data.content_type, x_sendfile: true, :filename => @uploaded_file.name
    else
      respond_to do |format|
        flash[:error]= "We're sorry, we could not download that file!"
        format.html { redirect_to root_path }
        format.json { head :no_content }
      end
    end
  end

  def download_shared_file
    @uploaded_file = UploadedFile.find_by_unique_url(params[:unique_url])

    respond_to do |format|      
      if @uploaded_file
        file = @uploaded_file.image
        if file.try(:file).exists?
          data = open(file.url)
          send_data data.read, type: data.content_type, x_sendfile: true, :filename => @uploaded_file.name
          return
        else
          flash[:error]= "We're sorry, we could not download that file!"
          format.html { redirect_to root_path }
          format.json { head :no_content }
        end
      else
        flash[:error]= "We're sorry, that file does not exist!"
        format.html { redirect_to root_path }
        format.json { head :no_content }
      end
    end
  end

  def share_file
    @storage = Storage.find_by_id(params[:storage_id])
    @uploaded_file = @storage.uploaded_files.find_by_id(params[:uploaded_file_id])
    @email = params[:email]
    @current_user = current_user

    respond_to do |format|
      if RailsValidator.validate_email(@email) && RailsValidator.validate_file(@uploaded_file.name, @uploaded_file.size)
        changed
        notify_observers(@email, @current_user, @uploaded_file.unique_url)
        format.html { redirect_to storage_uploaded_file_path(id: params[:uploaded_file_id], storage_id: params[:storage_id]), notice: 'Email sent successfully' }
        format.json { render :show, status: :created, location: @uploaded_file }
      else
        flash[:error] = "Invalid email, please try again!"
        format.html { redirect_to storage_uploaded_file_path(id: params[:uploaded_file_id], storage_id: params[:storage_id]), error: 'Invalid email' }
      end
    end
  end

  private

    def observer
      add_observer(EmailNotifier.new)
    end

    def update_storage_size
      @storage.set_size
      @storage.save
    end

    def get_storage
      @storage = Storage.find_by(user_id: current_user.id, id: params[:storage_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_uploaded_file
      if !@storage.nil?
        @uploaded_file = @storage.uploaded_files.find_by_id(params[:id])
      else
        flash[:error] = "File does not exist, or you do not have permission to access"
        redirect_to root_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def uploaded_file_params
      params.require(:uploaded_file).permit(:name, :image, :share_id, :unique_url)
    end
end
