class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[ show edit update destroy ]

  # GET /recipes or /recipes.json
  def index
    @recipes = Recipe.all
  end

  # GET /recipes/1 or /recipes/1.json
  def show
    @qtt = params[:qtt]&.to_f || 1.0
    helpers.debug(params[:qtt])
    helpers.debug(@qtt, '+')
    @nested_tree = expand(@recipe, @qtt)
    @materials = {}
    deep_count(@nested_tree)
    @materials = @materials.map{|key, values|
      [key, values.first, values.last]
    }.sort_by(&:last)
    @can_craft = get_possible_crafts(@recipe)
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
    @for = params[:for] || ""
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes or /recipes.json
  def create
    @recipe = Recipe.new(recipe_params)

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @recipe, notice: "Recipe was successfully created." }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1 or /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to @recipe, notice: "Recipe was successfully updated." }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1 or /recipes/1.json
  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to recipes_url, notice: "Recipe was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def expand(recipe, quantity=1.0)
      [[recipe.name, quantity], recipe.materials.to_materials.map{|material, q|
        r = material.to_recipe
        r ? expand(r, q * quantity / recipe.quantity) : [[material, q * quantity / recipe.quantity.to_f]]
      }]
    end

    def deep_count(array, depth = 0)
      material, quantity = array[0]

      @materials[material] = [(@materials[material]&.first || 0) + quantity, array.size > 1 ? [depth, (@materials[material]&.last || -1)].max : -1]
      if array.size > 1
        array[1].each do |elem|
          deep_count(elem, depth + 1)
        end
      end
    end

    def get_possible_crafts(recipe)
      Recipe.order(:priority).where("materials like ?", "%#{recipe.name} %")
    end

    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    def core_materials(materials)
      core_materials_2(materials).group_by(&:first).map{|k, v| [k, v.sum{|x|x[1]}, v.max_by(&:last)[2]]}.sort_by(&:last)
    end

    def core_materials_2(materials, depth = 0)
      materials.map{|material, quantity|
        recipes = Recipe.order(:priority).where(:name => material)
        if recipes.size > 0
          [[material, quantity.to_f, depth], core_materials_2(recipes[0].materials.to_materials(quantity.to_f / recipes[0].quantity.to_f), depth + 1)]
        else
          [material, quantity.to_f, -1]
        end
      }.flatten.each_slice(3).to_a
    end

    # Only allow a list of trusted parameters through.
    def recipe_params
      params.require(:recipe).permit(:name, :materials, :quantity, :extra, :priority, :image, :mod, :machine)
    end
end
