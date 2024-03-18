class ApplicationController < ActionController::API
    before_action :set_locale

    #:nodoc:
    def encode_token(payload)
        JWT.encode(payload, "secret")
    end

    #:nodoc:
    def decode_token
        auth_header = request.headers["Authorization"]
        if auth_header
            token = auth_header.split(" ").last
            begin
                JWT.decode(token, "secret", algorithm: 'HS256')
            rescue JWT::DecodeError
                nil
            end
        end
    end

    #:nodoc:
    def authorized_user
        if decode_token
            user_id = decode_token[0]["user_id"]
            @user = User.find_by_id(user_id)
            if @user
                return @user
            else
                return nil 
            end
        end
    end

    #:nodoc:
    def authorize
        not_logged_in unless authorized_user
    end

    #:nodoc:
    def not_logged_in
        render json: {message: "Você precisa estar logado"}, status: :unauthorized
    end

    private

    #:nodoc:
    def set_locale
        I18n.locale = :pt_BR
    end
end
