function git-unmodified
  set tmp_dir (mktemp -d)
  # Use this function to list all tracked files that are not modified
  # Note: Handles special Unicode characters by using null-terminated output
  
  # Enhanced version with better Unicode handling
  # Using null-terminated output and processing with perl
  git ls-files -z > $tmp_dir/all_files.bin
  git ls-files -z --modified > $tmp_dir/modified_files.bin
  
  # Use perl to read null-terminated files and find differences
  perl -0 -ne 'chomp; print "$_\n"' $tmp_dir/all_files.bin | sort > $tmp_dir/all_sorted.txt
  perl -0 -ne 'chomp; print "$_\n"' $tmp_dir/modified_files.bin | sort > $tmp_dir/mod_sorted.txt
  comm -23 $tmp_dir/all_sorted.txt $tmp_dir/mod_sorted.txt
  
  rm -rf $tmp_dir
end
