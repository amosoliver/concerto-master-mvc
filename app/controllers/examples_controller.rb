class ExamplesController < ApplicationController
  before_action :set_example, only: %i[show edit update destroy]

  def index
    @q = Example.ransack(params[:q])
    @examples = @q.result.order(created_at: :desc)
    @pagy, @examples = pagy(@examples, limit: 10)
  end

  def show; end

  def new
    @example = Example.new
  end

  def edit; end

  def create
    @example = Example.new(example_params)

    if @example.save
      redirect_to examples_path, notice: "#{Example.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @example.update(example_params)
      redirect_to examples_path, notice: "#{Example.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @example.discard
    redirect_to examples_path, notice: "#{Example.model_name.human} removido com sucesso."
  end

  private

  def set_example
    @example = Example.find(params[:id])
  end

  def example_params
    params.require(:example).permit(:name, :description)
  end
end
