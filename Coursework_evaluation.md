##Software Development Environment coursework**
<br>-Full name: Romain Charles Kuhne
<br>-Student ID: W1972584
<br>-University: University of Westminster
<br>-Course: Msc Software Engineer (Conversion)
<br>-Module leader: Dr George Charalambous

**Link for the Scheduler written in Bash:**
<br>here is the link (https://www.youtube.com/watch?v=kHDyX6tAUho&t=11s)
**Bash script**
````
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

``

**Requirement for the scheduler's program:**
__1) Correct parameters are entered:__
<br>The program must take as parameters:
<br>-File with the following process data: Process_name (char) Service_required (int) Arrival_time (int)
<br>-Priority increment for the new_queue: pr_new (int)
<br>-Priority increment for the ready_queue: pr_ready (int)

__2) Correct method of storage for the relevant process information:__
<br> In order to store the necessary data to enable the algorithm to effectively allocate processes to the rigth queue at the rigth time, an array called process_list was created. In the process_list array, each processes are stored on the process_list in the following format: <br>Process_name/Service_required/Arrival_time/Initial_priority/Initial_status/Mapping_integer

__3) Allocate the process on the rigth queue:__
<br>Each processes must be correctly allocated to the rigth queue. If the ready_queue is empty, the process will get allocated to the head of the ready_queue. In case the ready_queue is not empty, the process will get allocated at the tail of the ready_queue

__4) Changes in the process status:__
<br>To allow the program to correctly identify which process is running, waiting or terminated, or to allow the program to complete, the program must identify the rigth status: '-': Not allocated, 'W': Waiting, 'R': Running amd 'F': Completed.

__5) Increment priority:__
<br>Priorities on both queue must be incremented by the value stored by the argument pr_new pr_ready.

__6) Decrement Service required:__
<br>Service required must be decremented in each cycle for the process running on the head of the ready_queue

__7) Assess priorities:__
<br>The scheduler must be able to iterate through the new_queue and compare the priority of each process in it to the priority of the process running on the head of the ready_queue. This will allow to move processes with an identical priority from the new_queue to the ready_queue.

__8) Increment time quantum:__
<br>The Scheduler must increment the time_quantum value during each cycle to allow every block in the algorith to function properly.

__9) Switch process on ready_queue and identify when process finish executing:__
<br>The scheduler must allow to switch between processes in each cycles if the ready_queue contains other processes. Also the program must effectively be able to identify when a process finishes executing

__Logic behing the Scheduler's programm:__
```bash
    # 1) Verify right type of arguments entered;
    while (incorrect_data = true); do
        read "Enter a file name, new_queue priority and ready_queue priority" file_name p_new_queue p_ready_queue
        if (file_name dont exist || priorities not numbers); then
            print "Error! arguments not correct!"
        else
            print "Correct arguments were entered"
            incorrect_data=false

    #2) Store information concerning process in process_list array;
    for (elements in lines); do
        replace each whitespaces with '/' in a line
        add each lines representing processes to index [i] of process_list array
    done

    # 3) Buble sort: Sort process_list array from lowest arrival_time to highest;
    for (process in process_list array); do
        if (time arrival current process is > time arrival previous process)
        swap them
    done

    # 4) Append at each process in process_list array; /INITIAL_PRIORITY=0/INITIAL_STATUS='-'/Mapping_nbr;
    Initial_priority=0; initial_status='-'
    for (process in process_list array); do
        append '/'$initial_priority'/'$initial_status'/'$i
    done

    # 5) Prompt the user if he wants to print output in shell, in file or file + shell;
    while (incorrect_data = true); do
        read "Ask user if he wants to display output in file" user_input
        if ($user_input == Yes); then
            read "Ask user if want to display output in existing file" user_answe
            if ($user_answer == yes); then
                read "Ask user to type file_name" file_name
                Test if $file_name exist
                if ($file_name exist); then
                    break the loop
            else
                read "Ask user to create a file by entering a name of file" file_name
                test if $file_name is valid
                if ($file_name is valid); then
                    break the loop
        elif($user_input == no); then
        break the loop
    done

    # 6) Print upper quadrant of output if user wants to display it in standard output;
    # Format: Time process_name1 process_name2 process_name3 ...
    if (user wants to display output in standard output); then
        print T \c
        for (elements in process_list array); do
            print first character of elements == process_name \c
        done

    # 6) Write upper quadrant of output in file if user wanted to display in file  
    else
        print(T \c) > "$txt_file_name"
        for (elements in process_list array); do
            print first character of elements == process_name \c >> "$txt_file_name"
        done  


    # Selfish Round Robin Algorithm -----------------------------------------------------
    while (processes in process_list not completed); do
        while (process_nbr <= nbr_elements in process_list array); do # allocates processes in new or ready_queue
            
            # 7) Assess if ready_queue is empty and if true; allocate the process at head of ready_queue [0];
            if (head of ready_queue is empty && time_q == arrival time of process from process_list[process_nbr]) ; then
                allocate process from process_list[process_nbr] at head of ready_queue
                change status of the process from '-' to 'R'
                Update the change of process on head of ready_queue in process_list array
                increment pointer to next process process_nbr by 1
            
            # 8) If ready_queue is not empty; allocate the process at the tail of the new_queue;
            else
                allocate process at process_list[process_nbr] at tail of ready queue
                change status of the process from '-' to 'W'
                Update the change of process on the tail of new_queue in process_list array
                increment pointer to next process process_nbr by 1
        break
        done

   # 9) Decrease the service required of process running on head of ready_queue by 1 only if >= 1;
    if (head of ready_queue is not empty && priority of process at head of ready_queue >= 1); then
        decrement priority of the process by 1
        Update the change made to each process in the ready_queue to the process_list array
    
    # 10) Increment the priority of processes on the ready_queue by $p_ready_queue == 1;
    for(elements in ready_queue); do
        get priority of process and increment it by 1
        Update the change made to each process in the ready_queue to the process_list array
    done

    # 10) Increment the priority of processes on the new_queue by $p_new_queue == 2;
    for (process in new_queue); do
        get priority of process and increment it by 2
        Update the change made to each process in the new_queue to the process_list array
    done

    # 11) Display the change in time_quantum and process status from process_list array:
    if (user wants to display output in standard output); then
        print T \c
        for (process in process_list array)
            print first character of elements == process_name \c
        done
    else
        print T \c > "$txt_file_name"
        for (process in process_list array)
            print first character of elements == process_name \c >> "$txt_file_name"
        done  

    # 12) Assess whether every processes on the process list are completed (F);
    for (process in process_list array)
        get process status
        if (process_status is completed == 'F'); then
            proces in process_list not completed == false
        else
            proces in process_list not completed == true
    done


    # 13) Assess if the priority of p new_queue == p ready_queue;
    for (process in new_queue); do
        if (priority pf process in new_queue == priority of process at head of ready_queue); then
            allocate process from new_queue to the tail of the ready_queue
            dealocate the process moved from the new_queue to the ready_queue and shift all other processes leftward from one slot
        
    # 14) Assess if a process has terminated (if service_required reaches 0)
    if (service_required of process in head of ready_queue == 0); then
        update its status from 'R' to 'F' for completed
        update the change made to the completed process in the process_list array
        Remove the completed process from the head of ready_queue and restructure the ready_queue

        if (head of ready_queue is empty); then
            update the sataus of the process on the head of ready_queue from 'W' to 'R'
            update the change made to the completed process in the process_list array

    # 15) if process isn't terminate; Rearrange the ready_queue; P on head of ready_queue goes to the back and shift other processes leftward;
    elif (ready_queue contains other processes); done
        move process on head of ready queue to tail of ready_queue
        restructure the ready_queue by making the process at index[1] become index[0]
        update the status of the new process at the head of the ready_queue from 'W' to 'R'
        update the change made to the process in the process_list array
        update the status of the process moved to the tail of the ready_queue from 'R' to 'W'
        update the change made to the process in the process_list array
    
    # 16) Increment the time quantum by 1 during each cycles;
    time_quantum= (( $time_quantum + 1 ))
    done

    # 17) Ask the user if he wants to display the output from file in standard output;
    # Only ask if the user decided to write results on a file;
    if (user chose to write result in file); then
        read "Ask the user if he wants to display the result on file in standard output" user_input
        if ($user_input == yes); then
            use cat
        else 
            use regular print

    # 18) Display each processes on the process_list array to indicate program has finished running
    for (process in process_list array); do
        print (process)
    done
```
__1) Assessing the validity of user’s input:__
Prior to implementing the SRR algorithm, data collection was a prerequisite. In this step, a while loop with a read statement was created to prompt the user to enter the correct input as arguments: a file containing information about process entries, a priority increment for the new_queue and for the ready_queue. Within this loop, a conditional statement determines whether data file exists and if both priorities are numerical values. If the test fails, an error message will be displayed to the user, and the incorrect_input variable is not set to 0, preventing it from exiting the loop. In case the user enters the correct data and the test is validated, the variable incorrect_input will be set to 0, enabling to exit the verification loop and to continue the program.

__2) Storing the process entries in an array:__
In order to implement the SSR algorithm for the scheduler, three arrays were created: a process_list containing all the relevant information required by the by the algorithm respectively Process_name/Service_required_/Arrival_time/Initial_priority/Process_status/Mapping_integer**, a new_queue and a ready_queue. In the second step of the program, a for loop iterates through each lines representing a process entry and replace whitespaces by '/', joining the Process_name, Service_required and the Arrival_time.
At the end of the for loop, each index of the process_list array contains the following information in this specific format: <mark>Process_name/Service_required_/Arrival_time

__3) Bubble sort algorithm:__
To prevent processes with an arrival time that isn't equal to the time quantum from being allocated to a queue, it is crucial to order each process stored in the process_list array according to their arrival time from lowest to highest. To achieve this result, a Bubble Sort algorithm is implemented. This algorithm uses two nested for loops and compares the arrival time of a process at the current index j with a process at the previous index j-1. An if statement is then used to compare both values, and if the arrival time at index j is less than the arrival time at index j-1, the values at these indices are swapped.

__4) Add remaining information concerning process entries:__
In this stage, a for loop will append at the end of each string** an initial_priority with a value equal to 0** and an Process_status of '-' and a Mapping_integer separated by a '/'. At the end of this loop, each string will take the form: <mark>Process_name/Service_required/Arrival_time/Initial_priority/Process_status/Mapping_integer.

__5) Prompting display preferences according to the user:__
As required by the assignment, users must have the option to either print the output to standard output, write the result to a file, or do both. To implement this feature, a while loop was employed, evaluating a boolean variable called incorrect_data set to 1, representing the value True.

A read statement then prompts the user to indicate whether they want to write the output to a text file. The user can enter 'y/Y' or 'n/N'. If the user chooses not to write the result to a file, the boolean variable is set to 0, representing the value False, allowing the program to exit the loop.

If the user enters 'y' or 'Y', another read statement will inquire whether they want to write the result to an existing file. Once again, the user can decide to enter either 'y/Y' or 'n/N'. If 'y' or 'Y' is entered, the subsequent block of code will prompt the user to enter a file name and test if the file exists. If the test fails, a print function will display an error message stating that the file doesn't exist, and the loop will return to its initial state. If the test is validated, the boolean variable will be set to 0, enabling the exit from the while loop.

If the user enters 'n' or 'N', the following block of code will prompt the user to enter a file name to create a new file. Then, the input entered by the user will be evaluated to determine if the name is valid and will only create the file using the touch command if the test is evaluated as true

__6) Display the upper quadrant of the output:__
If The user chose to display in standard output, print Time T followed by processes names. Else, the quadrant will be written on a file entered by the user.
The output looks like this: <mark>T A B C D.

__7) Assess if ready_queue is empty:__
This code block will first assess if the ready_queue is empty, in case true, it will allocate the process on the head of the ready_queue at index i=0 and will then change its status from '-' to 'R'. Then, the process will be updated on the process_list array by retrieving its position indicated by the Mapping_integer. The block will then update its pointer to the next process to allocate to a queue.

__8) In case the ready_queue is not empty:__
The process will be allocated to the tail of the new_queue and will then change its status from '-' to 'W'. Then, the process will be updated on the process_list array by retrieving its position indicated by the Mapping_integer. The block will then update its pointer to the next process to allocate to a queue.

__9) Decrement Service_required of the process running on the ready_queue:__
During each cycle, the process running on the head of the ready_queue will see its priority value represented by the 2nd element between forward slash decrease by 1 as long as its value is >= 1

__10) Increment priority of processes on new_queue and ready_queue:__
For loop iterates throughout the processes on the new_queue and on the ready_queue and respectively increment their priority represented by the 4th element between forward slash by values entered by the user: p_new_queue p_ready_queue.

__11) Display the change in time_quantum and process status from process_list array:__
If The user chose to display in standard output, print Time T followed by processes names. Else, the quadrant will be written on a file entered by the user. The output would look like this for time_quantum T = 0:
T A B C D
0 R - - -

__12) Assess whether every processes on the process list are completed (F):__
A for loop assesses the status of each process in the process_list array and sets a boolean variable, which is tested inside the while loop, to false. This allows the program to exit the loop and terminate. If any of the statuses isn't equal to 'F', the variable is set to '1' or true.

__13) Assess if the priority of p new_queue == p ready_queue:__
Iterate through the each processes on the new_queue and test whether the priority of a process is equal to the priority of the process on the head of the ready_queue. If the test is evaluated as true, the process will be deallocated from the new_queue and will be placed on the tail of the ready_queue. The new_queue will have as head the next process. The process will be updated on the process_list array by retrieving its position indicated by the Mapping_integer.

__14) Assess if a process has terminated on the head of the ready_queue:__
An 'if' statement will assess whether the Service_required of the process running on the head of the ready_queue has reached 0. In case the test is evaluated as true, it will label it as completed and its status will be modified from 'R' to 'F' for finished. The process will be updated on the process_list array by retrieving its position indicated by the Mapping_integer. Then, the process will get removed from the head of the ready_queue by restructuring it. The next process at index 1 will be the new head of the ready_queue and its status will thus get changed from 'W' to 'R'. Finally, its status change will be updated in the process_list array.

__15) Switching processes on the ready_queue:__
To prevent running processes at the top of the ready_queue from monopolizing the resources of the CPU, it is crucial to switch between processes during each cycle. To achieve this, first, an if statement evaluates if the ready_queue contains other processes. If this is the case, the process running at the head of the ready_queue will be moved to the tail of the queue, and its status will be changed from 'R' to 'W'. This change is then reflected in the process_list array by utilizing its mapping integer.

After this step, the ready_queue is restructured by designating the next process at index 1 as the new head of the queue. Its status is also changed from 'W' to 'R', and this change is updated in the process_list array.

In the event that the process running at the head of the ready_queue is the only one in the queue, this process will continue running for another cycle.

__16) Increment the time_quantum:__
After each cycle, the time_quantum value will be incremented by 1.

__17) Display the result of the program:__
If the user chooses to display the time quantum, along with the evolution of each process status, in standard output, the information will be shown on the shell. If the user opts to write it to a file, the results will be displayed in the file specified by the user. Finally, if the user selects both options, the cat command will use the content written to the file to display it in the standard output.

**Testing the verification block on parameters:**
``` bash
# 1) ========================================================================================================================
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
```
__Entering a file that doesn't exist:__
<br>Thanks to the while loop, this block identify whenever the user enters a file which doesn't exist and if its the case it will display the root of the issue and will prompt the user to enter again the required parameters.
```
Enter the following parameters: a file, increase for new_queue and increment for ready queue: dont_exist 2 1
Error, the file dont exist! 
Enter the following parameters: a file, increase for new_queue and increment for ready queue:
```
__Entering characters instead of numerical values for both priorities__
<br>In case the user attempts to enter a non numerical input as priority for either's queue, the loop will display an error message stating that there was an issue with the parameters. The program will then display the correct type of parameter and will give an example of a correct entry.
```
Enter the following parameters: a file, increase for new_queue and increment for ready queue: data hey 2
Error! The incorrect parameter was entered 
This program takes:     File    Priority_number_new_queue       Priority_number_ready_queue 
Example of correct parameter:   File_exist      2       1 
Enter the following parameters: a file, increase for new_queue and increment for ready queue: 
```
__Entering an additional parameter:__
<br> In case a user enters an additional parameter, the loop will not validate this entry and like the exemple above will display an error message stating that there was an issue with the parameters. The program will then display the correct type of parameter and will give an example of a correct entry. The program however fails to identify and explain to the user the cause of the error.
```
Enter the following parameters: a file, increase for new_queue and increment for ready queue: data 2 1 3
Error! The incorrect parameter was entered 
This program takes:     File    Priority_number_new_queue       Priority_number_ready_queue 
Example of correct parameters:  File_exist      2       1 
Enter the following parameters: a file, increase for new_queue and increment for ready queue:
```

**Testing the storage of data from the file in the process_list array:**
```Bash
# 2) ========================================================================================================================
# Feature: Store processes information passed as the first parameter into the process_list array.
# Feature: Informations in process_list are stored as follow: PROCESS_NAME/SERVICE_REQUIRED/ARRIVAL_TIME.
nbr_processes=$(wc -l < "$file_name")
for ((i = 1; i <= "$nbr_processes"; i++)); do
    line_content=$(sed -n "${i}p" "$file_name" | tr ' ' '/')
    process_list+=("$line_content")
done
```
The for loop and with the 'sed' command effectively store the required information in the process_list array in the format: Process_name/Service_required/Arrival_time.
```
Enter the following parameters: a file, increase for new_queue and increment for ready queue: data 2 1
Correct parameters were entered. 

The content of process_list: A/6/0 B/5/1 C/4/3 D/2/4 
```
**Testing the option of display:**
<br>In case the user wants to display result in standard output:
```
Enter the following parameters: a file, increase for new_queue and increment for ready queue: data 2 1
Correct parameters were entered. 
Do you want to display the output to a text file: Y/N ? n
T  A  B  C  D 
0  R  -  -  - 
1  R  W  -  - 
2  W  R  -  - 
3  R  W  W  - 
4  W  R  W  W 
5  R  W  W  W 
6  W  R  W  W 
7  W  W  R  W 
8  R  W  W  W 
9  W  R  W  W 
10  W  W  W  R 
11  W  W  R  W 
12  R  W  W  W 
13  F  R  W  W 
14  F  F  W  R 
15  F  F  R  F 
16  F  F  R  F 
17  F  F  F  F 
```
<br>In case the user wants to write the result in a file:
```
Enter the following parameters: a file, increase for new_queue and increment for ready queue: data 2 1
Correct parameters were entered. 

========================================================================================================================
The following processes will be entered in the CPU: A/6/0/0/-/0 B/5/1/0/-/1 C/4/3/0/-/2 D/2/4/0/-/3 

/Users/romainkuhne/scheduler.sh: line 120: storage_file: command not found
Do you want to display the output to a text file: Y/N ? y
Do you want to display the output in an existing file ? Enter Y/N n
Please enter the name of the txt file where you want to display the output result.txt
result.txt was successfully created 

========================================================================================================================
                         - CPU has finished completing the processess after 19 cycles                                   
                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                                 
      Process_list containst the following process:  A/0/0/13/F/0 B/0/1/14/F/1 C/0/3/17/F/2 D/0/4/15/F/3 


romainkuhne@eroam-150-68 ~ % cat result.txt
T  A  B  C  D 
0  R  -  -  - 
1  R  W  -  - 
2  W  R  -  - 
3  R  W  W  - 
4  W  R  W  W 
5  R  W  W  W 
6  W  R  W  W 
7  W  W  R  W 
8  R  W  W  W 
9  W  R  W  W 
10  W  W  W  R 
11  W  W  R  W 
12  R  W  W  W 
13  F  R  W  W 
14  F  F  W  R 
15  F  F  R  F 
16  F  F  R  F 
17  F  F  F  F 

```
In case the user wants to store the result in a file and also want to display its content to standard output.
```
Enter the following parameters: a file, increase for new_queue and increment for ready queue: data 2 1
Correct parameters were entered. 

========================================================================================================================
The following processes will be entered in the CPU: A/6/0/0/-/0 B/5/1/0/-/1 C/4/3/0/-/2 D/2/4/0/-/3 

Do you want to display the output to a text file: Y/N ? y
Do you want to display the output in an existing file ? Enter Y/N n
Please enter the name of the txt file where you want to display the output test2.txt
test2.txt was successfully created 
Do you want to display result on the file in standard output: Y/y or N/n y
The result of the program written on the file is: 
T  A  B  C  D 
0  R  -  -  - 
1  R  W  -  - 
2  W  R  -  - 
3  R  W  W  - 
4  W  R  W  W 
5  R  W  W  W 
6  W  R  W  W 
7  W  W  R  W 
8  R  W  W  W 
9  W  R  W  W 
10  W  W  W  R 
11  W  W  R  W 
12  R  W  W  W 
13  F  R  W  W 
14  F  F  W  R 
15  F  F  R  F 
16  F  F  R  F 
17  F  F  F  F 

========================================================================================================================
                         - CPU has finished completing the processess after 19 cycles                                   
                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                                 
      Process_list containst the following process:  A/0/0/13/F/0 B/0/1/14/F/1 C/0/3/17/F/2 D/0/4/15/F/3 
```

**Testing the format of the process_list array:**
```bash
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
```
<br>The for loop that iterates throughout every processes on the process_list array successfully separate each information relevant for the SRR algorithm in the following format <mark>Process_name/Service_required/Arrival_time/Initial_priority/Process_status/Mapping_integer.

```
Enter the following parameters: a file, increase for new_queue and increment for ready queue: data 2 1
Correct parameters were entered. 

The following processes will be allocated to the CPU: A/6/0/0/-/0 B/5/1/0/-/1 C/4/3/0/-/2 D/2/4/0/-/3 
```
**Testing The priority of the process running on the head of ready_queue decreases during each cycle**
```bash
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
```
The process successfully decrement during each cycle by 1 the value of the priority of the process running on top of the ready_queue.
```
Enter the following parameters: a file, increase for new_queue and increment for ready queue: data 2 1
Correct parameters were entered. 

The following processes will be allocated to the CPU: A/6/0/0/-/0 B/5/1/0/-/1 C/4/3/0/-/2 D/2/4/0/-/3 
Do you want to display the output to a text file: Y/N ? n
T  A  B  C  D 

At time T = 0, before decrement: A/6/0/0/R/0 
At time T = 0, After decrement: A/5/0/0/R/0 

0  R  -  -  - 

At time T = 1, before decrement: A/5/0/1/R/0 
At time T = 1, After decrement: A/4/0/1/R/0 
```
**Testing if the priority of each processes in a queue increases:**
```bash
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
```
Both code blocks successfully increment the priority of processes on each queue during each cycle by the respective value passed by the user: pr_new and pr_ready.
```
Enter the following parameters: a file, increase for new_queue and increment for ready queue: data 2 1
Correct parameters were entered. 

The following processes will be allocated to the CPU: A/6/0/0/-/0 B/5/1/0/-/1 C/4/3/0/-/2 D/2/4/0/-/3 
Do you want to display the output to a text file: Y/N ? n
T  A  B  C  D 

At time T = 0, before priority increment, the ready_queue contains: A/5/0/0/R/0 
At time T = 0, after priority increment, the ready_queue contains: A/5/0/1/R/0 
At time T = 0, Before priority increment, the new_queue contains:  
At time T = 0, after priority increment, the new_queue contains:  

0  R  -  -  - 

At time T = 1, before priority increment, the ready_queue contains: A/4/0/1/R/0 
At time T = 1, after priority increment, the ready_queue contains: A/4/0/2/R/0 
At time T = 1, Before priority increment, the new_queue contains: B/5/1/0/W/1 
At time T = 1, after priority increment, the new_queue contains: B/5/1/2/W/1 

1  R  W  -  - 
```
**Testing if the program successfully can identify completed processes:**
```bash
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
        fi
```
Both blocks of code successfully identify when a process finishes running on the ready_queue and also successfully dealocate the completed process from the ready_queue to allow the next process to run. In addition, the change in status of the next process on the head of the ready_queue is effectively implemented as its status changes from 'W' to 'R'. 
```
12  R  W  W  W 

At time T = 12, ready_queue contains: : A/0/0/13/R/0 B/1/1/13/W/1 D/1/4/13/W/3 C/2/3/13/W/2 
At time T = 12, before check, the process on the head of ready_queue is: A/0/0/13/R/0 
At time T = 12, after check, the process on the head of ready_queue is: A/0/0/13/F/0 
At time T = 12, ready_queue contains: : B/1/1/13/R/1 D/1/4/13/W/3 C/2/3/13/W/2 

13  F  R  W  W 

At time T = 13, ready_queue contains: : B/0/1/14/R/1 D/1/4/14/W/3 C/2/3/14/W/2 
At time T = 13, before check, the process on the head of ready_queue is: B/0/1/14/R/1 
At time T = 13, after check, the process on the head of ready_queue is: B/0/1/14/F/1 
At time T = 13, ready_queue contains: : D/1/4/14/R/3 C/2/3/14/W/2 

```
***Testing if the program support more processes:**
```
romainkuhne@eroam-150-68 ~ % cat data
A 6 0
B 5 1
C 4 3
D 2 4
E 3 2
F 3 10
G 4 7
H 5 6%                      
```
In case the user add more than 4 processes with arrival time out of order, the program successfully sort each processes in order on the process_list array and support multiple digits data such as Arrival_time > 9. The program also seem to function properly to allow each processes to complete

```
Enter the following parameters: a file, increase for new_queue and increment for ready queue: data 2 1
Correct parameters were entered. 

The following processes will be allocated to the CPU: A/6/0/0/-/0 B/5/1/0/-/1 E/3/2/0/-/2 C/4/3/0/-/3 D/2/4/0/-/4 G/4/7/0/-/5 F/3/10/0/-/6 
Do you want to display the output to a text file: Y/N ? n
T  A  B  E  C  D  G  F 
0  R  -  -  -  -  -  - 
1  R  W  -  -  -  -  - 
2  W  R  W  -  -  -  - 
3  R  W  W  W  -  -  - 
4  W  R  W  W  W  -  - 
5  W  W  R  W  W  -  - 
6  R  W  W  W  W  -  - 
7  W  R  W  W  W  W  - 
8  W  W  W  R  W  W  - 
9  W  W  R  W  W  W  - 
10  R  W  W  W  W  W  W 
11  W  W  W  W  R  W  W 
12  W  R  W  W  W  W  W 
13  W  W  W  R  W  W  W 
14  W  W  R  W  W  W  W 
15  R  W  F  W  W  W  W 
16  F  W  F  W  R  W  W 
17  F  R  F  W  F  W  W 
18  F  F  F  W  F  R  W 
19  F  F  F  R  F  W  W 
20  F  F  F  W  F  R  W 
21  F  F  F  W  F  W  R 
22  F  F  F  R  F  W  W 
23  F  F  F  F  F  R  W 
24  F  F  F  F  F  W  R 
25  F  F  F  F  F  R  W 
26  F  F  F  F  F  F  R 
27  F  F  F  F  F  F  F 
```
**Testing the program with different priorities entered**
<br>Whenever the user enters different priority increments, such as 3 for the new_queue and 1 for the ready_queue, the program loops indefinitely, and the program crashes for unknown reasons. After some investigation, a weakness was found in the process_allocation process. Initially, processes are successfully allocated to both queues, but in cases where the ready_queue isn't empty, processes in the new_queue stay in the ready_queue, causing the program never to terminate.

<br>After a thorough investigation, it appears that the problem lies within the sharp difference in priority increase between the new_queue and the ready_queue. While the second allocation check within the nested 'while' loop ensures proper allocation to either queue, no code block prevented the case where the ready_queue is empty after process allocation. This is why only one process ended up completing, while the remaining processes kept piling up on the new_queue with their status remaining 'W'.

<br>This weakness was corrected by adding another feature to allocate the process at the head of the ready_queue in case the new_queue is empty.

```bash
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
```
Here is the output in case different priorities are entered.
In this example, a priority of 6 for the new_queue was entered and 1 for the ready_queue.
This extra layer of security enabled the program to support sharp differences of priorities.
```
Enter the following parameters: a file, increase for new_queue and increment for ready queue: data 6 1
Correct parameters were entered. 

The following processes will be allocated to the CPU: A/6/0/0/-/0 B/5/1/0/-/1 C/4/3/0/-/2 D/2/4/0/-/3 
Do you want to display the output to a text file: Y/N ? n
T  A  B  C  D 
0  R  -  -  - 
1  R  W  -  - 
2  R  W  -  - 
3  R  W  W  - 
4  R  W  W  W 
5  R  W  W  W 
6  F  W  W  W 
7  F  R  W  W 
8  F  R  W  W 
9  F  R  W  W 
10  F  R  W  W 
11  F  R  W  W 
12  F  F  W  W 
13  F  F  R  W 
14  F  F  R  W 
15  F  F  R  W 
16  F  F  R  W 
17  F  F  F  W 
18  F  F  F  R 
19  F  F  F  R 
20  F  F  F  F 

```
**Testing if two characters are supported on the data_file:**
<br>To test whether the program support multiple character in a data entry, the file was modified as followed:
```
romainkuhne@Romains-MacBook-Pro-2 ~ % cat data
A 6 0
B 5 1
C 4 3
DE 20 40
```
Although it seems that the program correctly stores multiple character data entry, the program unexpectedly crashed due to an infinite loop.
```
Enter the following parameters: a file, increase for new_queue and increment for ready queue: data 2 1
Correct parameters were entered. 

The following processes will be allocated to the CPU: A/6/0/0/-/0 B/5/1/0/-/1 C/4/3/0/-/2 DE/20/40/0/-/3 
Do you want to display the output to a text file: Y/N ? 
```

However, then only one field contains more than a single digit, the program doesn't crash and successfully terminates.
```
romainkuhne@Romains-MacBook-Pro-2 ~ % cat data
A 6 0
B 5 1
C 4 3
D 2 4
E 2 15
F 4 14
G 10 2
```
If we launch the program with the following process entry:
```
Enter the following parameters: a file, increase for new_queue and increment for ready queue: data 2 1
Correct parameters were entered. 

The following processes will be allocated to the CPU: A/6/0/0/-/0 B/5/1/0/-/1 G/10/2/0/-/2 C/4/3/0/-/3 D/2/4/0/-/4 F/4/14/0/-/5 E/2/15/0/-/6 
Do you want to display the output to a text file: Y/N ? n
T  A  B  G  C  D  F  E 
0  R  -  -  -  -  -  - 
1  R  W  -  -  -  -  - 
2  W  R  W  -  -  -  - 
3  R  W  W  W  -  -  - 
4  W  R  W  W  W  -  - 
5  W  W  R  W  W  -  - 
6  R  W  W  W  W  -  - 
7  W  R  W  W  W  -  - 
8  W  W  W  R  W  -  - 
9  W  W  R  W  W  -  - 
10  R  W  W  W  W  -  - 
11  W  W  W  W  R  -  - 
12  W  R  W  W  W  -  - 
13  W  W  W  R  W  -  - 
14  W  W  R  W  W  W  - 
15  R  W  W  W  W  W  W 
16  F  W  W  W  R  W  W 
17  F  R  W  W  F  W  W 
18  F  F  W  R  F  W  W 
19  F  F  R  W  F  W  W 
20  F  F  W  R  F  W  W 
21  F  F  R  F  F  W  W 
22  F  F  R  F  F  W  W 
23  F  F  R  F  F  W  W 
24  F  F  R  F  F  W  W 
25  F  F  R  F  F  W  W 
26  F  F  R  F  F  W  W 
27  F  F  F  F  F  W  W 
28  F  F  F  F  F  R  W 
29  F  F  F  F  F  R  W 
30  F  F  F  F  F  W  R 
31  F  F  F  F  F  R  W 
32  F  F  F  F  F  W  R 
33  F  F  F  F  F  R  F 
34  F  F  F  F  F  F  F 
```

**Conclusion:**
<br>Overall, based on the multiple phases of testing conducted, it appears that the scheduler's program is robust in various scenarios. However, the main weakness identified reveals that this program doesn't support adding two or more characters for the Process_name. Additionally, if the user enters multiple characters for the same entry, the program will crash. Further improvements could be made to prevent this issue, and the separation of tasks by including other functions could improve readability.