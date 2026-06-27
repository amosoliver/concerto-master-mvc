class MPessoasFuncoesController < ApplicationController
  before_action :set_m_pessoa_funcao, only: %i[show edit update destroy]

  def index
    @q = tenant_scope(MPessoaFuncao).ransack(params[:q])
    @m_pessoas_funcoes = @q.result.order(created_at: :desc)
    @pagy, @m_pessoas_funcoes = pagy(@m_pessoas_funcoes, limit: 10)
  end

  def show
  end

  def new
    @m_pessoa_funcao = MPessoaFuncao.new
  end

  def edit
  end

  def create
    @m_pessoa_funcao = MPessoaFuncao.new(m_pessoa_funcao_params)

    if @m_pessoa_funcao.save
      redirect_to @m_pessoa_funcao, notice: "#{MPessoaFuncao.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @m_pessoa_funcao.update(m_pessoa_funcao_params)
      redirect_to @m_pessoa_funcao, notice: "#{MPessoaFuncao.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @m_pessoa_funcao.discard
    redirect_to m_pessoas_funcoes_path, notice: "#{MPessoaFuncao.model_name.human} removido com sucesso."
  end

  private

  def set_m_pessoa_funcao
    @m_pessoa_funcao = tenant_record!(MPessoaFuncao, params[:id])
  end

  def m_pessoa_funcao_params
    params.require(:m_pessoa_funcao).permit(:g_pessoa_id, :u_funcao_id, :principal)
  end
end
