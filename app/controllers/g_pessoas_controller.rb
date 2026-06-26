class GPessoasController < ApplicationController
  before_action :set_g_pessoa, only: %i[show edit update destroy]

  def index
    @q = GPessoa.ransack(params[:q])
    @g_pessoas = @q.result.order(created_at: :desc)
    @pagy, @g_pessoas = pagy(@g_pessoas, limit: 10)
  end

  def show
  end

  def new
    @g_pessoa = GPessoa.new
  end

  def edit
  end

  def create
    @g_pessoa = GPessoa.new(g_pessoa_params)

    if @g_pessoa.save
      redirect_to @g_pessoa, notice: "G pessoa criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @g_pessoa.update(g_pessoa_params)
      redirect_to @g_pessoa, notice: "G pessoa atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @g_pessoa.discard
    redirect_to g_pessoas_path, notice: "G pessoa removido com sucesso."
  end

  private

  def set_g_pessoa
    @g_pessoa = GPessoa.find(params[:id])
  end

  def g_pessoa_params
    params.require(:g_pessoa).permit(:nome, :email, :g_entidade_id, :g_sexo_id)
  end
end
