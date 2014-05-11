require 'sinatra'
require './boot.rb'
require './money_calculator.rb'

# ROUTES FOR ADMIN SECTION
get '/admin' do
  @products = Item.all
  erb :admin_index
end

get '/new_product' do
  @product = Item.new
  erb :product_form
end

post '/create_product' do
	@item = Item.new
	@item.name = params[:name]
	@item.price = params[:price]
	@item.quantity = params[:quantity]
	@item.sold = 0
	@item.save
 	redirect to '/admin'
end

get '/edit_product/:id' do
  @product = Item.find(params[:id])
  erb :product_form
end

post '/update_product/:id' do
  @product = Item.find(params[:id])
  @product.update_attributes!(
    name: params[:name],
    price: params[:price],
    quantity: params[:quantity],
  )
  redirect to '/admin'
end

get '/delete_product/:id' do
  @product = Item.find(params[:id])
  @product.destroy!
  redirect to '/admin'
end
# ROUTES FOR ADMIN SECTION

get '/' do
  random = Item.all
  @products = random.sample(10)
  erb :index
end

get '/about' do
  erb :about
end

get '/products' do
  @products = Item.all
  erb :products
end

get '/purchase/:id' do
  @product = Item.find(params[:id])
  erb :purchase_form
end

post '/product_purchase/:id' do
  alerts = ""
  @alerts = alerts

  @product = Item.find(params[:id])

  quantity = params[:quantity]
  @quantity = quantity
  @total_cost = @quantity.to_i * @product.price
 
  if quantity.to_i > @product.quantity.to_i
    alerts = "There are insufficient stock for your transaction."
    @alerts = alerts

  else
    @alerts = alerts
    mc = MoneyCalculator.new params[:ones].to_i, params[:fives].to_i, params[:tens].to_i, params[:twenties].to_i, params[:fifties].to_i, params[:hundreds].to_i, params[:five_hundreds].to_i, params[:thousands].to_i
    @money_given = mc.total
    @hash = mc.change(@total_cost)

    if @total_cost.to_i > @money_given.to_i
  	alerts = "You have entered insufficient money for your transaction."
  	@alerts = alerts
  
    else
  	@change = @money_given - @total_cost
	left = @product.quantity.to_i - @quantity.to_i
	@product.sold = @product.sold + @quantity.to_i
	@product.update_attributes!(
        quantity: left,
        )
  	erb :confirmation
  end
end
end

post '/confirmation/:id' do
  @product = Item.find(params[:id])
end
