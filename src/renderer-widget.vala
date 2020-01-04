using Gtk;

public class RendererWidget : Frame
{
	public Renderer renderer;
	public Widget gst_widget;

	public RendererWidget(Renderer renderer, string label)
	{
		var label_widget = new Label("<b>"+label+"</b>");
		label_widget.set_use_markup(true);
		this.set_label_widget(label_widget);

		this.renderer = renderer;

		renderer.sink.get("widget", out gst_widget);

		gst_widget.hexpand = true;
		gst_widget.vexpand = true;

		this.add(gst_widget);

		this.button_press_event.connect(on_button_press);
	}

	public bool on_button_press(Gdk.EventButton event)
	{
		if (event.type == Gdk.EventType.BUTTON_PRESS && event.button == 3)
		{
			Gtk.Menu menu = new Gtk.Menu();
			menu.attach_to_widget(this, null);

			Gtk.MenuItem restart_menu_item = new Gtk.MenuItem.with_label("Restart");
			menu.add(restart_menu_item);

			Gtk.MenuItem edit_menu_item = new Gtk.MenuItem.with_label("Edit");
			menu.add(edit_menu_item);

			Gtk.MenuItem delete_menu_item = new Gtk.MenuItem.with_label("Delete");
			menu.add(delete_menu_item);

			menu.show_all();
			menu.popup_at_pointer(event);

			restart_menu_item.activate.connect(() =>
			{
				renderer.restart();
			});

			edit_menu_item.activate.connect(() =>
			{
				EditCameraDialog.edit_camera(renderer.camera);
			});

			delete_menu_item.activate.connect(() =>
			{
				renderer.stop();
				cameras.remove(renderer.camera);
				config.save();
				main_window.refresh_cameras();
			});

			return true;
		}

		if (event.type == Gdk.EventType.BUTTON_PRESS && event.button == 1)
		{
			main_window.show_renderer_fullscreen(this);
		}


		return false;
	}
}