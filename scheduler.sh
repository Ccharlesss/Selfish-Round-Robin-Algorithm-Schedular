function test {
# Parrameters necessary for the function to execute the Selfish Round Robin algorithm;
# Filename: File containing data about the processes.
# Pr_new: Priority of the new_queue.
# Pr_reay: Priority of the ready_queue.
typeset file_name; typeset pr_new; typeset pr_ready

# Iitiation of the required data structure to store the processes for the Selfish Round Robin algorithm;
# Process_list array: Stores all information regarding each processes. Processes dont get moved or removed from this array => Only for information and display purpose
# New_queue: Data structure used to store processes not yet ready to be executed by the CPU.
# Ready_queue: Data structure used to store processes ready to be executed by the CPU.
declare -a process_list; declare -a new_queue; declare -a ready_queue; declare -a completed_queue; 


# Feature: Just a original display screen when the program is launched;
printf "========================================================================================================================\n"
printf "|                    - Please take a seat and enjoy correcting my Software Development Coursework -                    |\n"
printf "|                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                  |\n"
printf "|                                                                                                                      |\n"
printf "|Full name: Romain Charles Kuhne                                                                                       |\n"
printf "|Student_id: W1972587                                                                                                  |\n"
printf "|Course: Software Development Environment                                                                              |\n"
printf "|Date of submission: 14/12/2023                                                                                        |\n"
printf "========================================================================================================================\n"
printf "\n"
printf "\n"



# 1) ========================================================================================================================
# Feature: While loop prompt the user to enter the correct parameter for the Selfish Round Robin algorithm to be executed;
# Feature: Ensure that the priorities entered by the user only contains digits.

# Expected result:
# Wrong data file => Display error message and prompr the user to enter rigth parameters.
# Non-numerical priorities => Display error message and prompr the user to enter rigth parameters.
# Correct parameters entered => Incorrect_data will be set to 0 (false) and the loop exit.

incorrect_data=1
# Loop as long as incorrect_data is True (0)
while [ "$incorrect_data" -eq 1 ]; do
        read -p "Enter the following parameters: a file, increase for new_queue and increment for ready queue: " file_name pr_new  pr_ready
        # Case where the correct parameters were entered;
        if [ -e $file_name ] && [[ "$pr_new" =~ ^[0-9]+$ && "$pr_ready" =~ ^[0-9]+$ ]]; then
                        printf "Correct parameters were entered. \n"
                        printf "\n"
                        incorrect_data=0
        elif [ ! -e $file_name ]; then
            printf "Error, the file dont exist! \n"

        # Case where the incorrect parameters were entered;
        else
                printf "Error! The incorrect parameter was entered \n"
                printf "This program takes: \tFile \tPriority_number_new_queue \tPriority_number_ready_queue \n"
                printf "Example of correct parameters: \tFile_exist \t2 \t1 \n"
        fi
done


# 2) ========================================================================================================================
# Feature: Store processes information passed as the first parameter into the process_list array.
# Feature: Informations in process_list are stored as follow: PROCESS_NAME/SERVICE_REQUIRED/ARRIVAL_TIME.
# Feature: Loops at every lines in the file provided as argument and replace whitespaces with /


while IFS= read -r line || [[ -n $line ]]; do
    if [[ -n $line ]]; then
        line_content=$(echo "$line" | tr ' ' '/')
        process_list+=("$line_content")
    fi
done < "$file_name"



# 3) ========================================================================================================================
# Feature: Buble sort algorithm enables to sort processes in the array according to FIFO (first in first to be out) => Sort processes in increasing order of time of arriva>
# Feature: Buble sort enables to compare both elements at same time at index [j=1] w/ [j-1] as long as j < nbr_element in array.
for ((i = 0; i<"${#process_list[@]}"; i++ )); do
        for (( j = 1; j < "${#process_list[@]}"; j++ )); do
                # If arrival_time enclosed in 3rd / at index [j=1] < the one at [j-1] => swap those values.
                if [[ $(echo "${process_list[j]}" | awk -F'/' '{print $3}') -lt $(echo "${process_list[j-1]}" | awk -F'/' '{print $3}') ]]; then
                        greater_value="${process_list[j-1]}"
                        process_list[j-1]="${process_list[j]}"
                        process_list[j]="$greater_value"
                fi
        done
done
#printf "The whole array contains the following elements: %s \n" "${process_list[*]}"


# 4) ========================================================================================================================
# Feature: Append to each process at index [i] in process_list array : /initial_priority=0/initial_status=-;
# Feature: Data is formated as follow: ex index process_list[i=0] {PROCESS_NAME/SERVICE_REQUIRED/ARRIVAL_TIME/INITIAL_PRIORITY/INITIAL_STATUS/Mapping_integer}
# Mapping integer is used to compute the position of the process in the process_list array to update it
initial_priority=0; initial_status="-"
for (( i = 0; i < "${#process_list[@]}"; i++ )) 
        do
                IFS='/' read -r process_name nbr_cycle arrival_time <<< "${process_list[i]}"
                process_list[i]="${process_name}/${nbr_cycle}/${arrival_time}/${initial_priority}/${initial_status}/${i}"
done
printf "The following processes will be allocated to the CPU: %s \n" "${process_list[*]}"



# 5) ========================================================================================================================
# Feature: Prompt the user whether he wants to only display the result of to display the output to a text file;
# Feature: If y|Y => ask the user if he want to display it in an existing text file or if he wish to create a new file;
# Feature: As long as the incorrect input is entered, the loop will prevent the program to continue.
incorrect_data=1; output_in_file=0; user_input=""; txt_file_name=""

# Loop as long as incorrect_data entered by the user is true (0).
while [ "$incorrect_data" -eq 1 ]; do
        # Prompr the user a display option: Display it in a file ? User can reply by entering either Y y or N n.
        read -p "Do you want to display the output to a text file: Y/N ? " user_input
        # If user_input == y || user_input == Y; ask the user if he wants to output result in existing file.
        if [[ "$user_input" =~ ^[yY]$ ]]; then
                read -p "Do you want to display the output in an existing file ? Enter Y/N " user_input
                # If user_input == y || user_input == Y; ask the user to enter the name of the file .
                if [[ "$user_input" =~ ^[yY]$ ]]; then
                        read -p "Please enter the name of the existing file " txt_file_name
                        # Assess if the file_name entered exist; if yes => Incorrect_data = false (0) => enable to exit loop.
                       if [ -e "$txt_file_name" ]; then
                                printf "The file %s exist. \n" "$txt_file_name"
                                output_in_file=1;incorrect_data=0
                                break
                        else # In case the file_name entered doesn't exist; display error message and return to the loop.
                                printf "The file %s doesn't exist. \n" "$txt_file_name"
                        fi
                # In case user_input == n || user_input == N; user dont want to display it in existing file.
                # Ask the user to create a file by entering a name.
                elif [[ "$user_input" =~ ^[nN]$ ]]; then
                        incorrect_data=1
                        # Prompt the user to enter a correct file_name loop entil a correct name is entered.
                        while [ "$incorrect_data" -eq 1 ]; do
                                read -p "Please enter the name of the txt file where you want to display the output " txt_file_name 
                                # If file_name is valid; Create the file using the touch command
                                if touch "$txt_file_name" ; then
                                        printf "%s was successfully created \n" "$txt_file_name"
                                        output_in_file=1; incorrect_data=0 # Set incorrect_data to false (1) to excit the both while loop.
                                        break
                                else # In case file_name entered isnt valid; display error message and return to nested.
                                printf "An error occured! Please enter a valid txt file name. \n"
                                fi
                        done

                # in case user doesn't enter a valid input; Display error message and return to the principal while loop
                else
                        printf "Invalid input! Please enter y/Y for yes or n/N for No. \n"
                fi

        # in case user_input == n || user_input == N; set incorrect_data as false (1) to exit the principal while loop
        elif [[ "$user_input" =~ ^[nN]$ ]]; then
                incorrect_data=0

        # in case user doesn't enter a valid input; Display error message and return to the principal while loop
        else
                printf "Invalid input! Please enter y/Y for yes or n/N for No. \n"
        fi
done




# 6) ========================================================================================================================
# Feature: Create the display format for the output: T p_name.
# Print T followed by process_name by displaying the first character on each string at index i of process_list array.

# Expected Result: T A B C B (if processes A, B, C and D are entered).
        if [ "$output_in_file" -eq 1 ]; then
                echo -e "T \c" > "$txt_file_name"
                for (( i = 0; i < "${#process_list[@]}"; i++ )); do
                        echo -e " ${process_list[i]:0:1} \c " >> "$txt_file_name"
                done
                printf "\n" >> "$txt_file_name"

        else
                echo -e "T \c"
                for (( i = 0; i < "${#process_list[@]}"; i++ )); do
                        echo -e " ${process_list[i]:0:1} \c "
                done
                printf "\n"
        fi

# 7) ========================================================================================================================
# Feature: Impplementation of Selfish-Round-Robin Algorithm;
# P_nbr: Used to indicate which process will get allocated to a queue.
# Time_q: Identify the time quantum to determine when a process should get allocated to a queue
# Process_list_completed = 0 (false): Enable for the loop to continue executing the algorithm as long as all processes status on process_list array != F
p_nbr=0; time_q=0; process_list_completed=0

# 1st while loop enables to continue as long as processes aren't completed (F)
while [[ "$process_list_completed" -eq 0 ]]; do
        # 2nr while loop enables to allocate each processes on process_list array to a queue.
        while [[ $p_nbr -lt "${#process_list[@]}" ]]; do # Enable to increase pointer p_nbr to the number of processes entered


# 8.1) ========================================================================================================================
# Feature: Assess if ready_queue is empty and if true; allocate the process at head of ready_queue [0]

                process_time=$(echo "${process_list[p_nbr]}" | awk -F'/' '{print $3}')
                if [[ $process_time == $time_q ]]; then
                #Test if ready queue is empty and if process arrival time == time_q
                        if [[ -z "${ready_queue[@]}" ]]; then
                # if true => Allocate process from top of process_list to head of ready queue
                                ready_queue+=("${process_list[p_nbr]}")
                # Update its status from (-) to (W):
                                ready_queue[0]=${ready_queue[0]/-/"R"}
                # Update the process from process list:
                                process_position=$(echo "${ready_queue[p_nbr]}" | awk -F'/' '{print $6}')
                                process_list[$process_position]="${ready_queue[0]}"
                                p_nbr=$(( $p_nbr + 1 ))
# 8.2) ========================================================================================================================
# Feature: If ready_queue is not empty; allocate the process at the tail of the new_queue

                # If head_ready_queue is not empty and process arrival time == time_q => Allocate process at tail of new_queue
                        else
                # If true => Allocate process to the tail of new_queue:
                                new_queue+=("${process_list[p_nbr]}")
                # Update its status from (-) to (W)
                                new_queue[${#new_queue[@]} - 1]=${new_queue[${#new_queue[@]} - 1]/-/"W"}
                # Update the process from the process list:
                                process_position=$(echo "${new_queue[${#new_queue[@]} - 1]}" | awk -F'/' '{print $6}')
                                process_list[$process_position]="${new_queue[${#new_queue[@]} - 1]}"
                                p_nbr=$(( $p_nbr + 1 ))
                        fi
                fi
        break
        done


# 8.3) ========================================================================================================================
# Feature:Decrease the service required of process running on head of ready_queue by 1 only if >= 1;
           
            if [[ -n "${ready_queue[0]}" && $(echo "${ready_queue[0]}" | awk -F'/' '{print $2}') -ge 1 ]]; then
                # Decrement the service required of process at ready_queue[0] by 1;
                current_service=$(echo "${ready_queue[0]}" | awk -F'/' '{print $2}')
                updated_service=$(( $current_service - 1 ))
                # Update the change in service required to the head of ready_queue
                ready_queue[0]=$(echo "${ready_queue[0]}" | awk -v new_value="$updated_service" -F'/' '{$2 = new_value; print}' OFS='/')
                # Update the change in service required in the process_list array;
                process_position=$(echo "${ready_queue[0]}" | awk -F'/' '{print $6}')
                process_list[$process_position]="${ready_queue[0]}"
        fi



# 8.4) ========================================================================================================================
# Feature: Increment the priority of processes on the ready_queue by 1;

        for ((i=0; i<"${#ready_queue[@]}"; i++)); do
                # Increment the priority of process i on the ready_queue
                process_priority=$(echo "${ready_queue[i]}" | awk -F'/' '{print $4}')
                updated_priority=$(( $process_priority + $pr_ready ))
                # Update the change in priority to the ready_queue;
                ready_queue[$i]=$(echo "${ready_queue[i]}" | awk -v new_value="$updated_priority" -F'/' '{$4 = new_value; print}' OFS='/')
                # Update the change in priority to the process_list;
                process_position=$(echo "${ready_queue[i]}" | awk -F'/' '{print $6}')
                process_list[$process_position]="${ready_queue[i]}"
        done

# Feature:Increment the priority of processes on the new_queue by 2;
        for ((i=0; i<"${#new_queue[@]}"; i++)); do
                # Increment the priority of process i on the new
                process_priority=$(echo "${new_queue[i]}" | awk -F'/' '{print $4}')
                updated_priority=$(( $process_priority + $pr_new ))
                # Update the change in priority to the new_queue
                new_queue[$i]=$(echo "${new_queue[i]}" | awk -v new_value="$updated_priority" -F'/' '{$4 = new_value; print}' OFS='/')
                # Update the change in priority to the process_list;
                process_position=$(echo "${new_queue[i]}" | awk -F'/' '{print $6}')
                process_list[$process_position]="${new_queue[i]}"
        done


# 8.5) ========================================================================================================================
# Feature: Display the change in process status in relation to time_q;
# Feature: Display each time_quantum increment followed by the process status changes
# Feature: Loop at process_list array and display the last element (PROCESS_STATUS) 

        if [ "$output_in_file" -eq 1 ]; then
                       echo -e "$time_q \c " >> "$txt_file_name"
                for ((i = 0; i<"${#process_list[@]}"; i++)); do
                        process_status=$(echo "${process_list[i]}" | awk -F'/' '{print $5}')
                        echo -e " $process_status \c " >> "$txt_file_name"
                done
                printf "\n" >> "$txt_file_name"

        else

                echo -e "$time_q \c "
                for ((i = 0; i<"${#process_list[@]}"; i++)); do
                        process_status=$(echo "${process_list[i]}" | awk -F'/' '{print $5}')
                        echo -e " $process_status \c "
                done
                printf "\n"
        fi



# Testing feature to determin the content of new_queue and ready_queue at each time_quantum
#        printf "At T= %s => new_queue contains: %s \n" "$time_q" "${new_queue[*]}"
#        printf "At T= %s => ready_queue contains: %s \n" "$time_q" "${ready_queue[*]}"


# 8.6) ========================================================================================================================
# Feature: Checks Whether every processes on the process list are completed (F)
# Feature: If all processes are comleted completed ∑ PROCESS_STATUE == F => Set process_list_completed to 1 => enable to exit the While loop terminates and terminate the p>

        for ((i=0; i<"${#process_list[@]}"; i++)); do
                if [[ $(echo "${process_list[i]}" | awk -F'/' '{print $5}') == 'F' ]]; then
                        process_list_completed=1
                else
                        process_list_completed=0
                        break
                fi
        done


# 8.7) ========================================================================================================================
# Feature: Assess if the priority of p new_queue == p ready_queu;
# If priority of new_queue == ready_queue => allocate the process from new_queue to tail of ready_queue

        for ((i=0; i<"${#new_queue[@]}"; i++)); do
                if [[ $(echo "${new_queue[i]}" | awk -F'/' '{print $4}') == $(echo "${ready_queue[0]}" | awk -F'/' '{print $4}') ]]; then
        # If true, allodate the process from new_queue to the tail of ready_queue;
                        ready_queue+=("${new_queue[i]}")
        # Move leftward all processes on the new_queue;
                        new_queue=("${new_queue[@]:0:i}" "${new_queue[@]:i+1}")
        # Adjust the index to avoid skipping the next element
                        i=$(( $i - 1))
                fi
        done


# 8.8) ========================================================================================================================
# Feature: Assess if a process has terminated (if service_required reaches 0)

        if [[ $(echo "${ready_queue[0]}" | awk -F'/' '{print $2}') == 0 ]]; then #&& $(echo "${process_list[0]}" | awk -F'/' '{print $5}') == R ]]; then
                # Update the completed process on head of ready_queue from (R) to (T);
                ready_queue[0]=${ready_queue[0]/"R"/"F"}
                # Update the completed process in the process_list array;
                process_position=$(echo "${ready_queue[0]}" | awk -F'/' '{print $6}')
                process_list[$process_position]="${ready_queue[0]}"
                # Remove the completed process from the head of ready_queue and restructure the new_queue
                ready_queue=("${ready_queue[@]:1}")

                # Change the status of the processs on the head of ready_queue from (W) to (R);
                if [[ -n "${ready_queue[0]}" ]]; then
                ready_queue[0]=${ready_queue[0]/"W"/"R"}
                # Update the change of status on the process_list;
                process_position=$(echo "${ready_queue[0]}" | awk -F'/' '{print $6}')
                process_list[$process_position]="${ready_queue[0]}"
                fi
# Feature: in case doesnt terminate; Rearrange the ready_queue; P on head of ready_queue goes to the back and shift other processes leftward;
        elif [[ -n "${ready_queue[1]}" ]]; then
                process_to_move="${ready_queue[0]}"
                ready_queue=("${ready_queue[@]:1}" "$process_to_move")
                # Change the status of the processs on the head of ready_queue from (W) to (R);
                ready_queue[0]=${ready_queue[0]/"W"/"R"}
                # Update the change of status on the process_list;
                process_position=$(echo "${ready_queue[0]}" | awk -F'/' '{print $6}')
                process_list[$process_position]="${ready_queue[0]}"
                # Change the status of the processs on the tail of ready_queue from (R) to (W);
                ready_queue[${#ready_queue[@]} - 1]=${ready_queue[${#ready_queue[@]} - 1]/"R"/"W"}
                # Back up the change of status on the process_list;
                process_position=$(echo "${ready_queue[${#ready_queue[@]} - 1]}" | awk -F'/' '{print $6}')
                process_list[$process_position]="${ready_queue[${#ready_queue[@]} - 1]}"

# Feature: Weakness corrector, extra check to allocate the first process on the new_queue to the ready_queue if it is empty;
# Feature: Prevent errors and infinit loops in case different priorities like pr_new = 3, pr_ready = 1 are entered
        elif [[ -z "${ready_queue[@]}" ]]; then
            # In case the ready_queue is empty, allocate the process on the head of new_queue to the ready_queue.
            ready_queue+=("${new_queue[0]}")
            # Update the status of the process added on the head of the ready_queue from 'W' to 'F'
            ready_queue[0]=${ready_queue[0]/"W"/"R"}
            # Updating these changes to the process_list array
            process_position=$(echo "${ready_queue[0]}" | awk -F'/' '{print $6}')
            process_list[$process_position]="${ready_queue[0]}"
            # Restructure the new_queue. The next process on the new_queue becomes the process on the head of the new_queue
            new_queue=("${new_queue[@]:1}")
        fi


# 8.9) ========================================================================================================================
# Feature: Increment the time quantum by 1;
        time_q=$(( $time_q + 1 ))
done

incorrect_data=1
if [ "$output_in_file" -eq 1 ]; then
    while [ "$incorrect_data" -eq 1 ]; do
        read -p "Do you want to display result on the file in standard output: Y/y or N/n " user_input
        if [[ "$user_input" =~ ^[yY]$ ]]; then
            printf "The result of the program written on the file is: \n"
            cat $txt_file_name
            break
        elif [[ "$user_input" =~ ^[nN]$ ]]; then
            incorrect_input=0
            break
        else
            printf "Please answer by yes: Y/y or no: N/n \n"
        fi
    done
fi

# 9) ========================================================================================================================
# Feature: Indicate the end of the program
printf "\n"
printf "========================================================================================================================\n"
printf "                                  - CPU has finished completing the processess                                          \n"
printf "                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                                 \n"
}

test
