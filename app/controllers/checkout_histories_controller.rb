class CheckoutHistoriesController < ApplicationController
  before_action :set_checkout_history, only: [:show, :edit, :update, :destroy]

  # GET /checkout_histories
  # GET /checkout_histories.json
  def index
    @checkout_histories = CheckoutHistory.all
  end

  # GET /checkout_histories/1
  # GET /checkout_histories/1.json
  def show
  end

  # GET /checkout_histories/new
  def new
    @checkout_history = CheckoutHistory.new
  end

  # GET /checkout_histories/1/edit
  def edit
  end

  # POST /checkout_histories
  # POST /checkout_histories.json
  def create
    @checkout_history = CheckoutHistory.new(checkout_history_params)

    respond_to do |format|
      if @checkout_history.save
        format.html { redirect_to @checkout_history, notice: 'Checkout history was successfully created.' }
        format.json { render :show, status: :created, location: @checkout_history }
      else
        format.html { render :new }
        format.json { render json: @checkout_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /checkout_histories/1
  # PATCH/PUT /checkout_histories/1.json
  def update
    respond_to do |format|
      if @checkout_history.update(checkout_history_params)
        format.html { redirect_to @checkout_history, notice: 'Checkout history was successfully updated.' }
        format.json { render :show, status: :ok, location: @checkout_history }
      else
        format.html { render :edit }
        format.json { render json: @checkout_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /checkout_histories/1
  # DELETE /checkout_histories/1.json
  def destroy
    @checkout_history.destroy
    respond_to do |format|
      format.html { redirect_to checkout_histories_url, notice: 'Checkout history was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_checkout_history
      @checkout_history = CheckoutHistory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def checkout_history_params
      params.require(:checkout_history).permit(:email, :ISBN, :checkout_timestamp, :return_timestamp)
    end
end
