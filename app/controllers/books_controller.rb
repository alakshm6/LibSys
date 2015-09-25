class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    if check_if_admin
      @book = Book.new
    elsif check_if_user
      respond_to do |format|
        format.html{redirect_to user_home_path, notice: 'Users cannot add new books.'}
      end
    else
      respond_to do |format|
        format.html{redirect_to login_path, notice: 'Only logged in admins can add new books.'}
      end
    end
  end

  # GET /books/1/edit
  def edit
    if check_if_admin
      @books = Book.where(id: params[:id])
    elsif check_if_user
      respond_to do |format|
        format.html{redirect_to user_home_path, notice: 'Users cannot add new books.'}
      end
    else
      respond_to do |format|
        format.html{redirect_to login_path, notice: 'Only logged in admins can add new books.'}
      end
    end
  end

  # POST /books
  # POST /books.json
  def create
    if check_if_admin
      @book = Book.new(book_params)

      respond_to do |format|
        if @book.save
          format.html { redirect_to @book, notice: 'Book was successfully created.' }
        else
          format.html { render :new }
        end
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    if check_if_admin
      respond_to do |format|
        if @book.update(book_params)
          format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    if check_if_admin
      if @book.status == "Available"
        @book.destroy
        respond_to do |format|
          format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
        end
      else
        respond_to do |format|
          format.html { redirect_to books_url, notice: 'Book cannot be deleted now because it is not available.' }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to user_home_path, notice: 'Only logged in admins can delete books' }
      end
    end
  end

  # CHECKOUT books
  def checkout
    @user = User.find_by_id(session[:current_user_id])

    @book = Book.find_by_id(params[:id])
    status = @book.status

    if status == 'Available'
      @book.status = 'Checked out'


      if (@user.user_type == 'A' || @user.user_type == 'P')

        @checkout_history = CheckoutHistory.new(:ISBN => @book.ISBN, :checkout_timestamp => DateTime.now.utc, :return_timestamp => DateTime.new(9999,12,31).utc)
        @book.save
        @checkout_history.save

        respond_to do |format|
              format.html { render :checkout_details }
              format.json { render json: @book }
            end
      else
         @checkout_history = CheckoutHistory.new(:email => @user.email, :ISBN => @book.ISBN, :checkout_timestamp => DateTime.now.utc, :return_timestamp => DateTime.new(9999,12,31).utc)
         @book.save
         @checkout_history.save
         respond_to do |format|
           format.html { redirect_to books_url, notice: 'Book was successfully checked out.' }
           format.json { head :no_content }
         end
      end
    else
      @book.status = 'Available'
      @book.save
      @checkout_history = CheckoutHistory.find_by(ISBN: @book.ISBN)
      @checkout_history.return_timestamp = DateTime.now.utc
      @checkout_history.save
      respond_to do |format|
        format.html { redirect_to books_url, notice: 'Book was successfully returned.' }
        format.json { head :no_content }
      end

    end
    end

  helper_method :checkout

  def checkout_details

  end

  def search

    session[:my_previous_url] = URI(request.referer || '').path
    @back_url = session[:my_previous_url]

  end

  def search_display

    value = params[:search_value].to_s.strip.squeeze

    session[:my_previous_url] = URI(request.referer || '').path #taken from stackoverflow
    @back_url = session[:my_previous_url] #taken from stackoverflow

    if params[:search_type]=='isbn'
      @books=Book.where('ISBN LIKE ?' , "%#{value}%")
      @book_count=Book.where('ISBN LIKE ?' , "%#{value}%").count

    elsif params[:search_type]=='title'
      @books=Book.where('title LIKE ?' , "%#{value}%")

    elsif params[:search_type]=='author'
      @books=Book.where('author LIKE ?' , "%#{value}%")

    elsif params[:search_type]=='description'
      @books=Book.where('description LIKE ?' , "%#{value}%")

    else
      @books=Book.where( status: 'Available')
    end

    @book_count = @books.count
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:ISBN, :title, :description, :author, :status)
    end
end
