require "application_system_test_case"

class RecipesTest < ApplicationSystemTestCase
  setup do
    @recipe = recipes(:one)
  end

  test "visiting the index" do
    visit recipes_url
    assert_selector "h1", text: "Recipes"
  end

  test "creating a Recipe" do
    visit recipes_url
    click_on "New Recipe"

    fill_in "Extra", with: @recipe.extra
    fill_in "Image", with: @recipe.image
    fill_in "Machine", with: @recipe.machine
    fill_in "Materials", with: @recipe.materials
    fill_in "Mod", with: @recipe.mod
    fill_in "Name", with: @recipe.name
    fill_in "Priority", with: @recipe.priority
    fill_in "Quantity", with: @recipe.quantity
    click_on "Create Recipe"

    assert_text "Recipe was successfully created"
    click_on "Back"
  end

  test "updating a Recipe" do
    visit recipes_url
    click_on "Edit", match: :first

    fill_in "Extra", with: @recipe.extra
    fill_in "Image", with: @recipe.image
    fill_in "Machine", with: @recipe.machine
    fill_in "Materials", with: @recipe.materials
    fill_in "Mod", with: @recipe.mod
    fill_in "Name", with: @recipe.name
    fill_in "Priority", with: @recipe.priority
    fill_in "Quantity", with: @recipe.quantity
    click_on "Update Recipe"

    assert_text "Recipe was successfully updated"
    click_on "Back"
  end

  test "destroying a Recipe" do
    visit recipes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Recipe was successfully destroyed"
  end
end
