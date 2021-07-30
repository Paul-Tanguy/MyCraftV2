class CoreMaterialController < ApplicationController
  def index()
    @materials = Recipe.all.map{|x|x.materials.to_materials.first.first}.uniq.select{|x| Recipe.where(:name => x).size == 0}
  end

  def show()
    @material = params[:material]
    @can_craft = get_possible_crafts(@material)
  end

  private
    def get_possible_crafts(material)
      Recipe.order(:priority).where("materials like ?", "%#{material} %")
    end  
end
