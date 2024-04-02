
using Plots
include("common_function.jl")


function plot_tour(coords, tour; title="")
    p = plot(coords[tour, 1], coords[tour, 2], legend=false, title=title, marker=:circle, markersize=5, linewidth=2, linecolor=:blue)
    plot!(p, [coords[tour[1], 1]], [coords[tour[1], 2]], markersize=8, markercolor=:red)
    return p
end

function two_opt_algorithm(dist_matrix, coords, n_inst, n_city)
    n = size(dist_matrix, 1)
    tour = collect(1:n)
    improvement = true
    plots = []

    while improvement
        improvement = false
        best_delta = 0
        best_i = 0
        best_j = 0

        for i in 1:n-2
            for j in i+1:n-1
                delta = dist_matrix[tour[i], tour[i+1]] + dist_matrix[tour[j], tour[j+1]] - (dist_matrix[tour[i], tour[j]] + dist_matrix[tour[i+1], tour[j+1]])
                if delta > best_delta
                    best_delta = delta
                    best_i = i
                    best_j = j
                end
            end
        end

        if best_delta > 0
            tour = two_opt_swap!(tour, best_i, best_j)
            improvement = true
            push!(plots, plot_tour(coords, tour, title="Step $(length(plots) + 1)"))
        end
    end

    gif_filename = "2-opt_tour_$(n_inst)_instances_$(n_city)_cities.gif"
    animate(plots, gif_filename, fps = 1)
    
    return tour, calculate_cost(dist_matrix, tour)
end

function experiment(n_instances, n_cities)
    lengths = Float64[]
    times = Float64[]

    for i in 1:n_instances
        seed = i  # 여기서 seed 값을 사용하는 것이 좋습니다.
        coords = generate_random_coordinates(n_cities, seed)  # `generate_random_coordinates` 함수가 seed를 인자로 받도록 수정 필요
        dist_matrix = create_distance_matrix(coords)

        start_time = time()
        _, tour_length = two_opt_algorithm(dist_matrix, coords, n_instances, n_cities)
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

function experiment_2a(instances_list, cities_list)
    for n_inst in instances_list
        for n_city in cities_list
            avg_length, std_length, avg_time, std_dev_time = experiment(n_inst, n_city)
            
            println("2_a: Results for N = $n_city cities with $n_inst instances:")
            println("Average Length: $(round(avg_length, digits=3))")
            println("Std Dev of Length: $(round(std_length, digits=3))")
            println("Average Time: $(round(avg_time, digits=3)) s")
            println("Std Dev of Time: $(round(std_dev_time, digits=3)) s")
            println()
        end
    end
end


#experiment_2a([100], [20, 50, 100])