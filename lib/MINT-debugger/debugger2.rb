begin
  require 'rubygems' 
rescue LoadError
end
require 'wx'
require 'time'
require 'dm-core'
require "MINT-core"

DataMapper.setup(:default, { :adapter => "rinda", :host =>"localhost",:port=>4000})
                       
ID_REFRESH = 1235
ID_DELETE_ENTRY = 1236

class NBPanel < Wx::Panel
    attr_accessor :win
    def initialize(parent)
        super(parent, -1)
        evt_size {|event| on_size(event)}
        @win
    end
    
    def on_size(event)
      win.set_size(event.get_size())
      win.notfifyNewSize(event.get_size())
    end
end

class DataModel < Wx::ListCtrl

  def initialize(col_labels,modelname,parent)
    super(parent, :style => Wx::LC_REPORT | Wx::LC_VIRTUAL)
    @col_labels = col_labels
    @modelname = modelname
    col_labels.each_with_index { |c,i|
      insert_column(i,c,Wx::LIST_FORMAT_LEFT, -1)
      set_column_width(i,175)
    }

    @query = [modelname]
    col_labels.each { 
      @query << nil
    }
    
    read_data(modelname)
    
    #  to fill the data into the list using the on_get_item_text callbacks
    set_item_count @data.size
  end

 def read_data (modelname)
   
   @data = []
   
   result = modelname.class.all
   result.each do |entry|
      row = []
      @col_labels.each do |col|
        row << entry.method(col.intern).call
      end
      @data << row
    end

    p @data
   @data
 end
  
  def delete_data(items)
    items.sort!{|x,y| y <=> x }
    
    items.each { |i|
      query = { }
      @col_labels.each_with_index do |col,j|
         query[col]=@data[i][j] 
      end
      p "Delete query #{query.inspect}"
      result = @modelname.class.first(query)
      p "Delete result #{result.inspect}"
      result.destroy!
      @data.delete_at(i)
    }
    refresh_data
  end
    
 def refresh_data
   read_data (@modelname)
   set_item_count @data.size
   refresh_items(0,@data.size)
   p "Refresh to #{@data.size}"
 end
  
  # use array like indexing of fields in Struct to
  # directly retrieve data for display
  def on_get_item_text(item, column)
    @data[item][column].to_s

  end
  
  # used to rearrange columns width's based on window width 
  def notfifyNewSize(size)
    @col_labels.each_with_index { |c,i|
      set_column_width(i,size.get_width/@col_labels.size)
    }
  end
end

# A Wx::Frame is a self-contained, top-level Window that can contain
# controls, menubars, and statusbars
class MinimalFrame < Wx::Frame
  def initialize(title)
    # The main application frame has no parent (nil)
    super(nil, :title => title, :size => [ 800, 600 ])

    @logo_icon = Wx::Image.new(File.dirname(__FILE__)+"/MINT-Logo-short-bg.png") # load the image from the file
    @logo_image  = Wx::Bitmap.new(@logo_icon)
   
    
   @licence = File.read(File.dirname(__FILE__)+"/licence-code.txt") 
    
    splash = Wx::SplashScreen.new(@logo_image,
                                  Wx::SPLASH_CENTRE_ON_SCREEN|Wx::SPLASH_TIMEOUT,
                                  3000, nil, -1)
       
    @model_panels=[]
    
    menu_bar = Wx::MenuBar.new
    # The "file" menu
    menu_file = Wx::Menu.new
    # Using Wx::ID_EXIT standard id means the menu item will be given
    # the right label for the platform and language, and placed in the
    # correct platform-specific menu - eg on OS X, in the Application's menu
    menu_file.append(Wx::ID_EXIT, "E&xit\tAlt-X", "Quit this program")
    menu_file.append(ID_REFRESH, "&Refresh\tAlt-R", "Refresh models")
    
    menu_bar.append(menu_file, "&File")
    
    # The Model menu
   # menu_model= Wx::Menu.new
    #menu_model.append(ID_DELETE_ENTRY, "&Delete Entry\tAlt-D", "Deletes Selected Entries")
    #menu_bar.append(menu_model, "&Model")
    
    # The "help" menu
    menu_help = Wx::Menu.new
    menu_help.append(Wx::ID_ABOUT, "&About...\tF1", "Show about dialog")
    menu_bar.append(menu_help, "&Help")

    # Assign the menubar to this frame
    self.menu_bar = menu_bar

    # Create a status bar at the bottom of the frame
    @status_bar = create_status_bar(2)
    self.status_text = "Happy debugging!"

    # Set it up to handle menu events using the relevant methods. 
    evt_menu Wx::ID_EXIT, :on_quit
    evt_menu Wx::ID_ABOUT, :on_about
    evt_menu(ID_REFRESH) { |event| refreshAllModels(event,self)}
    evt_menu(ID_DELETE_ENTRY) { |event| deleteEntry(event)}
    
   @m_notebook = Wx::Notebook.new(self, -1,Wx::DEFAULT_POSITION,
                             Wx::DEFAULT_SIZE)
   
    # Task Model
    panel = create_list_panel(@m_notebook, MINT::Task.new, ["name","states","abstract_states","new_states","description"])
    @m_notebook.add_page(panel,"Task-Model",TRUE)    
    
    # AUI Model
    panel = create_list_panel(@m_notebook, MINT::AIO.new, ["name","class","states","abstract_states","new_states","label","description"])
    @m_notebook.add_page(panel,"AUI-Model",TRUE)    

    # PTS Model
    panel = create_list_panel(@m_notebook, MINT::PTS.new, ["name","states","abstract_states","new_states"])
    @m_notebook.add_page(panel,"PTS",TRUE)

    # Domain
    #panel = create_list_panel(@m_notebook, Domain.new, ["task","description","options"])
    #@m_notebook.add_page(panel,"Domain-Model",TRUE)    
    
    # CUI
    #     panel = create_list_panel(@m_notebook, MINT::Box.new, ["name","state","x","y","width","height","layer"])
    #    @m_notebook.add_page(panel,"CUI-Model-Box",TRUE)    
       
    #  CUI Layout-Calc
     panel = create_list_panel(@m_notebook, MINT::CIO.new, ["name","class","states","abstract_states","new_states","width","height","x","y","layer","row","col"])
                                                            #"text","minwidth","minheight","optspace","minspace",
    @m_notebook.add_page(panel,"CUI-gfx",TRUE)    
    
    # Mouse
     panel = create_list_panel(@m_notebook, MINT::Pointer3D.new, ["name","states","abstract_states","new_states","x","y","z"])
    @m_notebook.add_page(panel,"MouseHTML",TRUE)    
    
    # IR
     panel = create_list_panel(@m_notebook, MINT::OneHand.new, ["class","name","states","abstract_states","new_states","amount"])
    @m_notebook.add_page(panel,"Gesture",TRUE)    
    # IR
     panel = create_list_panel(@m_notebook, MINT::Element.new, ["class","name","states","abstract_states","new_states"])
    @m_notebook.add_page(panel,"Element",TRUE)    
  end
  
  def refreshAllModels(event,frame)
    p "Refresh all"
    @model_panels.each { |p|
      p.refresh_data
    }
    @status_bar.push_status_text "Refreshed at #{Time.now}"
  end
 
  def deleteEntry(event)
    p "Delete Entry"
    selections = @m_notebook.get_current_page.win.get_selections
    @m_notebook.get_current_page.win.delete_data(selections)
  end
  
  def  create_list_panel(notebook, modelname, col_labels)
    panel = NBPanel.new(notebook)

    list = DataModel.new(col_labels,modelname,panel)
    @model_panels << list
    panel.win = list


    box = Wx::BoxSizer.new(Wx::HORIZONTAL)
    box.add(panel, 1, Wx::EXPAND)
    panel
  end
  # End the application; it should finish automatically when the last
  # window is closed.
  def on_quit
    close()
  end

  # show an 'About' dialog - WxRuby's about_box function will show a
  # platform-native 'About' dialog, but you could also use an ordinary
  # Wx::MessageDialog here.
  def on_about
    Wx::about_box(:name => self.title,
                   :version     => "1.0",
                   :description => "This is the initial version of the MINT Debugger",
                   :developers  => ['Dr.-Ing. Sebastian Feuerstack'] ,
                  :copyright => "(C) Sebastian Feuerstack 2010",
                  :web_site => "http://www.multi-access.de",
                  :licence => @licence,
                  :icon => Wx::Icon.from_bitmap(@logo_image))
  end
end
