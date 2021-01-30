#!/bin/bash
echo 'Batch High Throughput Virtual Screening, Rac Mukkamala'
echo 'A combination of ORCA, OpenBabel, MGLTools, and Autodock Vina'
echo $'Please acknowledge use of this script as follows!\n'
echo 'Mukkamala, R (2020) Batch High Throughput Virtual Screening Script (Version 1.0) [Source code]. https://github.com/RackS103/Batch-HTVS'
echo $'\nStarting batch job....\n'
Errors=[]

htvs_params=$2
orca_path=$(cat "$2" | head -1 | sed 's/PATH: //')
inp_header=$(cat "$2" | head -2 | tail -1 | sed 's/ORCAHEADER: //')
mgl_path=$(cat "$2" | head -3 | tail -1 | sed 's/MGL: //')
vina_params=$(cat "$2" | head -4 | tail -1 | sed 's/VINA: //')
receptor=$(cat "$2" | head -5 | tail -1 | sed 's/RECEPTOR: //')
echo "HTVS DOCKING RESULTS" >> "$1/htvs_summary.txt"

for input in $1/*.inp
do
  filename=$(echo $input | sed 's/\.inp//')
  molecule=$(echo $input | sed 's/.*\///;s/\..*//')
  fullpath="$filename/$molecule"
  
  if grep -q "$orca_header" "$filename.inp";
  then
    mkdir "$filename"
    mv "$filename.inp" $filename
    echo "$molecule: Correct input parameters, Starting ORCA..."
    echo "------------------------------------------------------"
    "$orca_path" "$fullpath.inp" > "$fullpath.output" &
    orca_process_id=$!
    wait $orca_process_id

    if grep -q 'ORCA TERMINATED NORMALLY' "$fullpath.output";
    then
      echo "$molecule: Success! ORCA terminated normally! Now converting to PDBQT...."
      echo "-------------------------------------------------------------------------"
      obabel "$fullpath.xyz" -O "$fullpath.pdb"
      python "$mgl_path" -l "$fullpath.pdb" -v -o "$fullpath.pdbqt"
      
      echo "$molecule: Running Autodock Vina...."
      vina --receptor "$receptor" --config "$vina_params" --ligand "$fullpath.pdbqt" --log "${fullpath}_results.txt"
      vina_process_id=$!
      wait $vina_process_id
      
      result=$(grep "REMARK VINA RESULT:" "${fullpath}_out.pdbqt" | head -1 | sed 's/REMARK VINA RESULT: *//;s/ *.*//')
      echo "$molecule: RESULT! Binding score of $result"
      echo "$molecule = $result" >> "$1/htvs_summary.txt"

    else
      echo "$filename: ERROR! ORCA had an runtime issue."
      Errors+="$filename"
    fi
    
  else
    echo "$filename: ERROR! Incorrect ORCA input file parameters."
    echo "The proper input header is $inp_header"
    Errors+="$filename"
  fi
  echo $'Moving on to the next file...\n'
done

echo 'Batch HTVS job finished'
echo 'The following files had errors:'
echo ${Errors[*]}
