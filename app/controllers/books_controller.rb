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
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # CHECKOUT books
  def checkout
    @user = User.find_by_id(session[:current_user_id])

    @book = Book.find_by_id(params[:id])
    status = @book.status


    if status == 'Available'
      @book.status = 'Checked out'
      @book.save

      if (@user.user_type == 'A')

        @checkout_history = CheckoutHistory.new(:ISBN => @book.ISBN, :checkout_timestamp => DateTime.now.utc, :return_timestamp => DateTime.new(9999,12,31).utc)
        @checkout_history.save
        respond_to do |format|
              format.html { render :checkout_details }
              format.json { render json: @book }
            end
      else
         @checkout_history = CheckoutHistory.new(:email => @user.email, :ISBN => @book.ISBN, :checkout_timestamp => DateTime.now.utc, :return_timestamp => DateTime.new(9999,12,31).utc)
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
