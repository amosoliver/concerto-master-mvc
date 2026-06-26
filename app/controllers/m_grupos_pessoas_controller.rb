class MGruposPessoasController < ApplicationController
  before_action :set_m_grupo_pessoa, only: %i[show edit update destroy]

  def index
    @q = MGrupoPessoa.ransack(params[:q])
    @m_grupos_pessoas = @q.result.order(created_at: :desc)
    @pagy, @m_grupos_pessoas = pagy(@m_grupos_pessoas, limit: 10)
  end

  def show
  end

  def new
    @m_grupo_pessoa = MGrupoPessoa.new
  end

  def edit
  end

  def create
    @m_grupo_pessoa = MGrupoPessoa.new(m_grupo_pessoa_params)

    if @m_grupo_pessoa.save
      redirect_to @m_grupo_pessoa, notice: "M grupo pessoa criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @m_grupo_pessoa.update(m_grupo_pessoa_params)
      redirect_to @m_grupo_pessoa, notice: "M grupo pessoa atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @m_grupo_pessoa.discard
    redirect_to m_grupos_pessoas_path, notice: "M grupo pessoa removido com sucesso."
  end

  private

  def set_m_grupo_pessoa
    @m_grupo_pessoa = MGrupoPessoa.find(params[:id])
  end

  def m_grupo_pessoa_params
    params.require(:m_grupo_pessoa).permit(:g_pessoa_id, :m_grupo_id)
  end
end
