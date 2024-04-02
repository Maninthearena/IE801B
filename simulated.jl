include("common_function.jl")


function simulated_annealing_two_opt(dist_matrix; temp=5000.0, cooling_rate=0.99, min_temp=0.1)
    n = size(dist_matrix, 1)
    current_tour = greedy_initial_tour(dist_matrix)
    best_tour = copy(current_tour)
    best_cost = calculate_cost(dist_matrix, best_tour)
    
    while temp > min_temp
        i, j = distinct_random_pair(n)
        
        new_tour = two_opt_swap!(current_tour, i, j)
        new_cost = calculate_cost(dist_matrix, new_tour)
        cost_diff = new_cost - best_cost
        
        if cost_diff < 0 || exp(-cost_diff / temp) > rand()
            current_tour = copy(new_tour)
            if new_cost < best_cost
                best_tour = copy(new_tour)
                best_cost = new_cost
            end
        end
        
        temp *= cooling_rate
    end
    
    return best_tour, best_cost
end

function distinct_random_pair(n)
    i, j = rand(1:n), rand(1:n)
    while i == j
        j = rand(1:n)
    end
    return i < j ? (i, j) : (j, i)
end

function greedy_initial_tour(dist_matrix)
    n = size(dist_matrix, 1)
    visited = Bool[false for _ in 1:n]
    tour = [1]
    visited[1] = true
    
    for _ in 2:n
        last = tour[end]
        next_index = find_next_nearest_unvisited(dist_matrix, last, visited)
        push!(tour, next_index)
        visited[next_index] = true
    end
    
    return tour
end

function find_next_nearest_unvisited(dist_matrix, last, visited)
    distances = dist_matrix[last, :]
    min_dist, next_index = Inf, 0
    for i in 1:length(distances)
        if !visited[i] && distances[i] < min_dist
            min_dist = distances[i]
            next_index = i
        end
    end
    return next_index
end

function experiment(n_instances, n_cities)
    lengths = Float64[]
    times = Float64[]

    for i in 1:n_instances
        seed = i
        coords = generate_random_coordinates(n_cities, seed)
        dist_matrix = create_distance_matrix(coords)

        start_time = time()
        _, tour_length = simulated_annealing_two_opt(dist_matrix)
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

function experiment_simulated(instances_list, cities_list)
    for n_inst in instances_list
        for n_city in cities_list
            avg_length, std_length, avg_time, std_dev_time = experiment(n_inst, n_city)
            
            println("Simulated Annealing: Results for N = $n_city cities with $n_inst instances:")
            println("Average Length: $(round(avg_length, digits=3))")
            println("Std Dev of Length: $(round(std_length, digits=3))")
            println("Average Time: $(round(avg_time, digits=3)) s")
            println("Std Dev of Time: $(round(std_dev_time, digits=3)) s")
            println()
        end
    end
end

#experiment_simulated([100, 200, 300, 400, 500, 600, 700, 800, 900, 1000], [20, 50, 100])
