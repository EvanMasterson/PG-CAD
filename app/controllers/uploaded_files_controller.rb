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

    # get the filename and the size from the uploaded file parameters
    name = params[:uploaded_file][:image].original_filename
    size = :image.size

    respond_to do |format|
      # validate file with our custom gem that checks name, extension and size
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
    # foind the uploaded file with the unique_url
    @uploaded_file = UploadedFile.find_by_unique_url(params[:unique_url])

    respond_to do |format|      
      if @uploaded_file
        # associate file with the imagesaved to the database
        file = @uploaded_file.image
        if file.try(:file).exists?
          # if the file exists, we open it with the url. This returns a File object, so
          # we are able to call functions on it as read
          data = open(file.url)
          # uses X-SendFile to send the file when set to true
          # Since it is using the webserver to send files, it may lower memory consumtion on the server
          # and may not block the application for further requests
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
    # find storage by storage_id and find file by uploaded_file_id
    @storage = Storage.find_by_id(params[:storage_id])
    @uploaded_file = @storage.uploaded_files.find_by_id(params[:uploaded_file_id])
    # take email as a param from the view
    @email = params[:email]
    # define current user with Devise's built in current_user
    @current_user = current_user

    respond_to do |format|
      # validate email and file with our custom gem
      if RailsValidator.validate_email(@email) && RailsValidator.validate_file(@uploaded_file.name, @uploaded_file.size)
        # set changed flag to true otherwise notification won't be sent
        changed
        # notify observer and pass the email where we want the email to be sent, the current user and the url that can be clicked
        notify_observers(@email, @current_user, @uploaded_file.unique_url)
        # redirect and show success message
        format.html { redirect_to storage_uploaded_file_path(id: params[:uploaded_file_id], storage_id: params[:storage_id]), notice: 'Email sent successfully' }
        format.json { render :show, status: :created, location: @uploaded_file }
      else
        # flash error and redirect
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
      # find storage by the logged in user_id and storage_id to prevent unaythorised access to storages
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
