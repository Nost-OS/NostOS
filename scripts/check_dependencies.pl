use strict;
use warnings;

# List of required tools
my @tools = ("git", "make", "nasm");

foreach my $tool (@tools)
{
  # Check in the tool is installed
  my $result = `which $tool 2>/dev/null`;
  chomp($result);

  if ($result)
  {
    print "$tool is installed at $result\n";
  }
  else
  {
    print "$tool is not installed. Installing $tool...\n";
    # Invoke system command to install the dependency
    system("sudo apt-get install -y $tool");
  }
}