class MArranjosController < ApplicationController
  before_action :set_m_arranjo, only: %i[show edit update destroy manage_files update_files]
  before_action :load_attachment_collections, only: %i[show manage_files update_files]
  before_action :load_form_collections, only: %i[new create edit update]

  def index
    @q = tenant_scope(MArranjo).ransack(params[:q])
    @m_arranjos = @q.result.order(created_at: :desc)
    @pagy, @m_arranjos = pagy(@m_arranjos, limit: 10)
  end

  def show
  end

  def manage_files
  end

  def new
    @m_arranjo = MArranjo.new(m_musica_id: selected_musica&.id)
  end

  def edit
  end

  def create
    @m_arranjo = MArranjo.new(m_arranjo_persistence_params)
    assign_virtual_attributes

    if MArranjos::ServicoCriacao.new(m_arranjo: @m_arranjo, params: m_arranjo_params).call
      redirect_to after_save_path_for(@m_arranjo), notice: "#{MArranjo.model_name.human} criado com sucesso."
    end
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  def update
    @m_arranjo.assign_attributes(m_arranjo_persistence_params)
    assign_virtual_attributes

    if MArranjos::ServicoAtualizacao.new(m_arranjo: @m_arranjo, params: m_arranjo_params).call
      redirect_to after_save_path_for(@m_arranjo), notice: "#{MArranjo.model_name.human} atualizado com sucesso."
    end
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @m_arranjo.discard
    redirect_to m_arranjos_path, notice: "#{MArranjo.model_name.human} removido com sucesso."
  end

  def update_files
    attach_arranjo_arquivos!
    attach_instrumento_arquivos!

    redirect_to after_files_update_path, notice: "Arquivos do arranjo atualizados com sucesso."
  rescue ActiveRecord::RecordInvalid
    render :manage_files, status: :unprocessable_entity
  end

  private

  def set_m_arranjo
    @m_arranjo = tenant_record!(MArranjo, params[:id])
  end

  def m_arranjo_params
    params.require(:m_arranjo).permit(:descricao, :m_musica_id, :m_tipo_arranjo_id, :m_arranjador_id, :m_tonalidade_id, :novo_m_arranjador, :from_musica_management, g_instrumento_naipe_ids: [])
  end

  def m_arranjo_persistence_params
    m_arranjo_params.except(:novo_m_arranjador, :from_musica_management, :g_instrumento_naipe_ids)
  end

  def load_form_collections
    @m_musicas = tenant_musica_scope
    @m_tipos_arranjos = MTipoArranjo.order(:descricao)
    @m_arranjadores = MArranjador.order(:descricao)
    @m_tonalidades = MTonalidade.order(:descricao)
    @g_instrumentos_naipes = GInstrumentoNaipe.includes(:g_instrumento, :g_naipe).sort_by(&:to_s)
  end

  def assign_virtual_attributes
    @m_arranjo.novo_m_arranjador = m_arranjo_params[:novo_m_arranjador]
  end

  def selected_musica
    return @selected_musica if defined?(@selected_musica)

    musica_id = params[:m_musica_id].presence || params.dig(:m_arranjo, :m_musica_id).presence || @m_arranjo&.m_musica_id
    @selected_musica = musica_id.present? ? tenant_record!(MMusica, musica_id) : nil
  end

  def after_save_path_for(m_arranjo)
    return manage_arranjos_m_musica_path(m_arranjo.m_musica) if m_arranjo_params[:from_musica_management] == "1"

    m_arranjos_path
  end

  def after_files_update_path
    return params[:return_to] if params[:return_to].present? && params[:return_to].start_with?("/")

    manage_arranjos_m_musica_path(@m_arranjo.m_musica)
  end

  def load_attachment_collections
    @instrumentos_do_arranjo = @m_arranjo.m_arranjos_instrumentos_naipes
                                     .includes(:g_instrumento_naipe, arquivo_attachments: :blob)
                                     .order(:id)
  end

  def attach_arranjo_arquivos!
    arquivos = Array(params.dig(:m_arranjo, :audio)).reject(&:blank?)
    return if arquivos.blank?

    @m_arranjo.audio.attach(arquivos)
  end

  def attach_instrumento_arquivos!
    raw_files = params[:instrumento_arquivos]
    return if raw_files.blank?

    raw_files.to_unsafe_h.each do |relation_id, files|
      relation = @m_arranjo.m_arranjos_instrumentos_naipes.find_by(id: relation_id)
      next unless relation

      attachments = Array(files).reject(&:blank?)
      next if attachments.blank?

      relation.arquivo.attach(attachments)
    end
  end
end
