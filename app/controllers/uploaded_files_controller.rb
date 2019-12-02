require 'observer'
class UploadedFilesController < ApplicationController
  include Observable
  before_action :observer, only: [:share_file]
  before_action :get_storage
  before_action :set_uploaded_file, only: [:show, :edit, :update, :destroy]

  # GET /uploaded_files
  # GET /uploaded_files.json
  def index
    @uploaded_files = @storage.uploaded_files
  end

  # GET /uploaded_files/1
  # GET /uploaded_files/1.json
  def show
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
      format.html { redirect_to storage_uploaded_files_path(@storage), notice: 'Uploaded file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def download_file
    set_uploaded_file
    file = @uploaded_file.image

    if file.try(:file).exists?
      data = open(file.url)
      send_data data.read, type: data.content_type, x_sendfile: true
    end
  end

  def download_shared_file
    set_uploaded_file
  end

  def share_file
    # @email =
    # @uploaded_file =

    changed
    notify_observers(@email, @uploaded_file.image)
  end

  private

    def observer
      add_observer(EmailNotifier.new)
    end

    def get_storage
      @storage = Storage.find(params[:storage_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_uploaded_file
      @uploaded_file = @storage.uploaded_files.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def uploaded_file_params
      params.require(:uploaded_file).permit(:name, :image, :share_id, :unique_url)
    end
end
