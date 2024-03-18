class InvoicesController < ApplicationController
  before_action :authorize
  before_action :set_invoice, only: %i[ show update destroy ]

  # GET /invoices
  #
  # Retorna todas as Invoices em ordem decrescente de criação
  def index
    @invoices = Invoice.all.order(created_at: :desc)

    render json: @invoices
  end

  # GET /invoices/1
  #
  # Mostra uma invoice
  #
  # url_param: id
  def show
    render json: @invoice
  end

  # POST /invoices
  #
  # Cria uma invoice, todos os params são obrigatórios
  #
  # Retorna erro ao falhar, mostrando em português
  #
  # params: [:name, :card_number, :value, :due_date, :cvv]
  def create
    @invoice = Invoice.new(invoice_params)

    if @invoice.save
      render json: {success: true, data: @invoice}, status: :created, location: @invoice
    else
      render json: {errors: @invoice.errors, success: false}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /invoices/1
  #
  # Atualiza uma invoice, todos os params são obrigatórios
  #
  # url_param: id
  #
  # params: [:name, :card_number, :value, :due_date, :cvv]
  def update
    if @invoice.update(invoice_params)
      render json: @invoice
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # DELETE /invoices/1
  #
  # Deleta uma invoice
  #
  # param: id
  def destroy
    @invoice.destroy!
  end

  private
    
    #:nodoc:
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    #:nodoc:
    # Only allow a list of trusted parameters through.
    def invoice_params
      params.require(:invoice).permit(:name, :card_number, :value, :due_date, :cvv)
    end
end
