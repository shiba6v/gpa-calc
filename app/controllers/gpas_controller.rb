require 'concerns/calc.rb'
#require 'pry'

class GpasController < ApplicationController
  include Calculator

  before_action :set_gpa, only: [:show, :edit, :update, :destroy]

  # GET /gpas
  # GET /gpas.json
  def index
    @gpas = Gpa.all
  end

  # GET /gpas/1
  # GET /gpas/1.json
  def show
  end

  # GET /gpas/new
  def new
    @gpa = Gpa.new
  end

  # GET /gpas/1/edit
  def edit
  end

  # POST /gpas
  # POST /gpas.json
  def create
    @gpa = Gpa.new(gpa_params)

    if gpa_pdf["file"].nil?
      redirect_to @gpa, notice: 'PDFがありません．'
      return
    end

    calc gpa_pdf["file"].read

    respond_to do |format|
      if @gpa.save
        format.html { redirect_to @gpa, notice: 'GPAが算出されました．' }
        format.json { render :show, status: :created, location: @gpa }
      else
        format.html { render :new }
        format.json { render json: @gpa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gpas/1
  # PATCH/PUT /gpas/1.json
  def update
    if !@gpa.authenticate(gpa_params[:password])
      redirect_to @gpa, notice: 'パスワードが違います．'
      return
    end

    if gpa_pdf["file"].nil?
      redirect_to @gpa, notice: 'PDFがありません．'
      return
    end

    calc gpa_pdf["file"].read

    respond_to do |format|
      if @gpa.update(gpa_params)
        format.html { redirect_to @gpa, notice: 'GPAが更新されました．' }
        format.json { render :show, status: :ok, location: @gpa }
      else
        format.html { render :edit }
        format.json { render json: @gpa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gpas/1
  # DELETE /gpas/1.json
  def destroy
    @gpa.destroy
    respond_to do |format|
      format.html { redirect_to gpas_url, notice: 'GPAが削除されました．' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gpa
      @gpa = Gpa.find(params[:id])
      @gpa.password_digest
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gpa_params
      params.fetch(:gpa, {}).permit(:name, :password)
    end

    def gpa_pdf
      params.fetch(:gpa, {}).permit(:file)
    end


end
