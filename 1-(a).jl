include("common_function.jl")


function two_opt_algorithm(dist_matrix)
    n = size(dist_matrix, 1)
    tour = collect(1:n)
    improvement = true
    while improvement
        improvement = false
        for i in 1:n-2
            for j in i+1:n-1
                new_tour = two_opt_swap!(tour, i, j)
                delta = calculate_cost(dist_matrix, tour) - calculate_cost(dist_matrix, new_tour)
                if delta > 0
                    tour = new_tour
                    improvement = true
                end
            end
        end
    end
    return tour, calculate_cost(dist_matrix, tour)
end

function experiment(n_instances, n_cities)
    lengths = Float64[]
    times = Float64[]

    for i in 1:n_instances
        seed = i
        coords = generate_random_coordinates(n_cities, seed)
        dist_matrix = create_distance_matrix(coords)

        start_time = time()
        _, tour_length = two_opt_algorithm(dist_matrix)
        end_time = time()

        push!(lengths, tour_length)
        push!(times, end_time - start_time)
    end

    avg_length = mean(lengths)
    std_length = std(lengths)
    avg_time = mean(times)
    std_dev_time = std(times)

    return avg_length, std_length, avg_time, std_dev_time
end

function experiment_1a(instances_list, cities_list)
    for n_inst in instances_list
        for n_city in cities_list
            avg_length, std_length, avg_time, std_dev_time = experiment(n_inst, n_city)
            
            println("1_a: Results for N = $n_city cities with $n_inst instances:")
            println("Average Length: $(round(avg_length, digits=3))")
            println("Std Dev of Length: $(round(std_length, digits=3))")
            println("Average Time: $(round(avg_time, digits=3)) s")
            println("Std Dev of Time: $(round(std_dev_time, digits=3)) s")
            println()
        end
    end
end

#experiment_1a([100, 200, 300, 400, 500, 600, 700, 800, 900, 1000], [20, 50, 100])