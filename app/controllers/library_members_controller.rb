class LibraryMembersController < ApplicationController
  before_action :set_library_member, only: [:show, :edit, :update, :destroy]

  # GET /library_members
  # GET /library_members.json
  def index
    @library_members = LibraryMember.all
  end

  # GET /library_members/1
  # GET /library_members/1.json
  def show
  end

  # GET /library_members/new
  def new
    @library_member = LibraryMember.new
  end

  # GET /library_members/1/edit
  def edit
  end

  # POST /library_members
  # POST /library_members.json
  def create
    @library_member = LibraryMember.new(library_member_params)

    respond_to do |format|
      if @library_member.save
        format.html { redirect_to @library_member, notice: 'Library member was successfully created.' }
        format.json { render :show, status: :created, location: @library_member }
      else
        format.html { render :new }
        format.json { render json: @library_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /library_members/1
  # PATCH/PUT /library_members/1.json
  def update
    respond_to do |format|
      if @library_member.update(library_member_params)
        format.html { redirect_to @library_member, notice: 'Library member was successfully updated.' }
        format.json { render :show, status: :ok, location: @library_member }
      else
        format.html { render :edit }
        format.json { render json: @library_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /library_members/1
  # DELETE /library_members/1.json
  def destroy
    @library_member.destroy
    respond_to do |format|
      format.html { redirect_to library_members_url, notice: 'Library member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_library_member
      @library_member = LibraryMember.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def library_member_params
      params.require(:library_member).permit(:email, :name, :encrypted_password, :salt)
    end
end
