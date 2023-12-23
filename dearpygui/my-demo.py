import dearpygui.dearpygui as dpg
import math
from math import sin, cos
import random


def on_start_click(sender, app_data, user_data):
    print(sender, app_data, user_data)


def main():
    dpg.create_context()

    font_name = "./fonts/Happy-Monkey/HappyMonkey-Regular-1.ttf"
    default_font = None
    default_font_size = 30

    with dpg.font_registry():
        # first argument ids the path to the .ttf or .otf file
        default_font = dpg.add_font(font_name, size=default_font_size)

    dpg.create_viewport(title='Custom Title', width=800, height=600)

    with dpg.window(width=1000, height=800, pos=(0, 0), no_collapse=True, no_title_bar=True, no_background=True, no_close=True, no_resize=True, no_move=True):
        dpg.add_text("This is a simple text")
        dpg.add_input_text(hint="Username")
        dpg.add_input_text(hint="Passward", password=True)
        dpg.add_button(label="Start", callback=on_start_click, small=False)
        dpg.add_checkbox(label="save password")
        # dpg.set_item_font(dpg.last_item(), default_font)

    # Bindding all f
    for item in dpg.get_all_items():
        dpg.bind_item_font(item, default_font)

    dpg.setup_dearpygui()
    dpg.show_viewport()
    dpg.start_dearpygui()
    dpg.destroy_context()


if __name__ == '__main__':
    main()
