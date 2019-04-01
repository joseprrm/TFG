from kivy.app import App
from kivy.lang.builder import Builder
from kivy.uix.label import Label
from kivy.uix.boxlayout import BoxLayout
from kivy.properties import ObjectProperty
from kivy.properties import StringProperty
from kivy.uix.switch import Switch

import subprocess
import sys


Builder.load_string('''
<MyLabel@Label>:
    bcolor: 1, 0, 0
    color: 0,0,0,1 
    font_size: '30dp'
    canvas.before:
        Color:
            rgb: self.bcolor
        Rectangle:
            pos: self.pos
            size: self.size

<MyBoxLayout@BoxLayout>
    orientation:'horizontal'
    text:''
    service:''
    MySwitch:
        label:myswitch1
        service:root.service
        active:True
    MyLabel:
        id:myswitch1
        text:root.text

<GUI>:
    BoxLayout:
        orientation:'vertical'
        MyBoxLayout:
            text:'bftpd'
            service:'bftpd'
        MyBoxLayout
            text:'haveged'
            service:'haveged'
''')

class MySwitch(Switch):
    label=ObjectProperty(None)
    service=StringProperty()
    def __init__(self,**kwargs):
        super(MySwitch,self).__init__(**kwargs)

    def on_active(self,instance,value):
        if value is True:
            print(self.service)
            proc=subprocess.Popen("ssh raspi sudo  systemctl restart "+self.service,stdout=subprocess.PIPE,shell=True)
            self.label.bcolor=(0,1,0)
        else:
            proc=subprocess.Popen("ssh raspi sudo systemctl stop "+self.service,stdout=subprocess.PIPE,shell=True)
            self.label.bcolor=(1,0,0)


class GUI(BoxLayout):
    pass

class MainApp(App):
    def build(self):
        return GUI()

MainApp().run()
