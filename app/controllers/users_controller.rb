class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  #
  # Lista todos os usuários
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  #
  # Mostra um usuário
  #
  # url_param: id
  def show
    render json: @user
  end

  # POST /users
  #
  # Cria um usuário
  #
  # params: [:username, :password]
  def create
    @user = User.new(user_params)
    if @user.valid?
      token = encode_token({user_id: @user.id})
    end
    if @user.save
      render json: {user: @user, token: token}, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  #
  # Atualiza um usuário
  #
  # url_param: id
  #
  # params: [:username, :password]
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  #
  # Exclui um usuário
  #
  # url_param: id
  def destroy
    @user.destroy!
  end

  # POST /users/login
  #
  # Login do user
  #
  # retorna o token de autenticação para ser usado em outras requisições
  #
  # params: [:username, :password]
  def login
    @user = User.find_by(username: user_params[:username])
    if @user && @user.authenticate(user_params[:password])
      token = encode_token({user_id: @user.id})
      render json: {user: @user, token: token}, status: :created, location: @user
    else
      render json: {errors: "Usuario ou senha inválidos"}, status: :unprocessable_entity
    end
  end

  private
    # :nodoc:
    def set_user
      @user = User.find(params[:id])
    end

    # :nodoc:
    def user_params
      params.permit(:username, :password)
    end
end
