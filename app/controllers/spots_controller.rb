require 'pry'

class SpotsController < ApplicationController
  before_action :set_spot, only: [:show, :edit, :update, :destroy]

  # GET /spots
  # GET /spots.json
  def index
    # json = HTTParty.post('http://localhost:3000/authenticate', body: {email: 'admin@railz.com', password: '666'})
    @spots = []
    Spot.destroy_all
    @json = HTTParty.get("http://localhost:3000/spots" )
    @json.each do |spot|
      spot = Spot.create!({
        :name => spot.fetch('name'),
        :lat => spot.fetch('lat'),
        :lon => spot.fetch('lon'),
        :description => spot.fetch('description'),
        :spot_type => spot.fetch('spot_type'),
        :features => spot.fetch('features'),
        :img => spot.fetch('img'),
        :id => spot.fetch('id'),
        :created_at => spot.fetch('created_at'),
        :updated_at => spot.fetch('updated_at'),
        # calc on front end instead of storing in api's db ??? --v
        # :avg_rating => spot.fetch('avg_rating')
        })
        @spots.push(spot)
      end
    end

    # GET /spots/1
    # GET /spots/1.json
    def show
      @response = HTTParty.get("https://api.openweathermap.org/data/2.5/weather?lat=#{@spot.lat}&lon=#{@spot.lon}&appid=#{Rails.application.credentials.weather_api_key}")
    end

    # GET /spots/new
    def new
      @spot = Spot.new
    end

    # GET /spots/1/edit
    def edit
    end

    # POST /spots
    # POST /spots.json
    def create
      @spot = Spot.new(spot_params)
      HTTParty.post("localhost:3000/spots?name='#{@spot.name}'&lat=#{@spot.lat}&lon=#{@spot.lon}&description='#{@spot.description}'&features='#{@spot.features}'&spot_type='#{@spot.type}'&img='#{@spot.img}'")

      respond_to do |format|
        if @spot.save
          format.html { redirect_to @spot, notice: 'Spot was successfully created.' }
          format.json { render :show, status: :created, location: @spot }
        else
          format.html { render :new }
          format.json { render json: @spot.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /spots/1
    # PATCH/PUT /spots/1.json
    def update
      respond_to do |format|
        if @spot.update(spot_params)
          format.html { redirect_to @spot, notice: 'Spot was successfully updated.' }
          format.json { render :show, status: :ok, location: @spot }
        else
          format.html { render :edit }
          format.json { render json: @spot.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /spots/1
    # DELETE /spots/1.json
    def destroy
      HTTParty.delete("http://localhost:3000/spots/#{@spot.id}")
      @spot.destroy
      respond_to do |format|
        format.html { redirect_to spots_url, notice: 'Spot was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_spot
      @spot = Spot.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spot_params
      params.require(:spot).permit(:name, :lat, :lon)
    end
  end
