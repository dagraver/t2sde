#include <vector>
#include <iostream>
#include <fstream>


class Tag {
public:
  
  Tag(const std::string& i_short_name,
	  const std::string& i_name,
	  const std::string& i_long_name)
    : short_name(i_short_name), name(i_name),
      long_name(i_long_name)
  {
  }
  
  virtual ~Tag(){};
  
  virtual std::istream& Read(std::istream& is)
  {
    return is;
  }
  virtual std::ostream& Write(std::ostream& os)
  {
    return os;
  }
  
  std::string short_name;
  std::string name;
  std::string long_name;
  
  std::string value;
};


class TagParser
{
protected:
  
  TagParser () {}
  virtual ~TagParser () {}

public:
  
  // erases all tag's data
  void Clear() {
    for (std::vector<Tag*>::size_type i = 0;
	 i < tags.size(); ++i)
	tags[i]->value.clear();
  }

  bool Parse(const std::string& file)
  {
    int error = 0;
    
    // parse
    std::fstream src_file(file.c_str());
    
    std::string line;
    std::string tag, value;
    for (int linenr = 0; src_file; ++linenr) {
      std::getline(src_file, line);
      
      if (line.size() == 0)
	continue;
      
      // skip comments (maybe we also need to compress
      // whitespaces? -ReneR
      if (line[0] == '#' || line[0] == ' ')
	continue;
      
      if (line.size() < 3) {
	++error;
	std::cerr << file << ":"
		  << linenr << ": only garbage in this line." << std::endl
		  << "  '" << line << "'" << std::endl;
      }
      
      std::string::size_type idx = line.find(' ');
      if (idx == std::string::npos)
	idx = line.size();
      
      if (line[0] != '[' || line[idx - 1] != ']') {
	++error;
	std::cerr << file << ":" << linenr << ": this line contains no tag." << std::endl
		  << "  '" << line << "'" << std::endl;
	continue;
      }
      
      tag.erase();
      tag.append(line, 1, idx - 2);
      value.erase();
      value.append(line, idx, std::string::npos);
      
      // search thru "registered" tags
      bool tag_found = false;
      for (std::vector<Tag*>::size_type i = 0;
	   i < tags.size(); ++i) {
	if (tag == tags[i]->short_name ||
	    tag == tags[i]->long_name ||
	    tag == tags[i]->name)
	  {
	    tags[i]->value.append (value + '\n');
	    tag_found = true;
	    break;
	  }
      }
      
      if (!tag_found) {
	++error;
	std::cerr << file << ":" << linenr << ": Unknown tag '" << tag << "'" << std::endl;
      }
    }
    return error == 0;
  }

  // derived class has to fill this vector
  std::vector<Tag*> tags;

};
