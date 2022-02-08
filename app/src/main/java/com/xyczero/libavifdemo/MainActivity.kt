package com.xyczero.libavifdemo

import android.os.Bundle
import com.google.android.material.snackbar.Snackbar
import androidx.appcompat.app.AppCompatActivity
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.ImageView
import com.xyczero.libavif.AvifDecoder
import java.io.ByteArrayOutputStream
import java.io.IOException
import java.io.InputStream

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_main)

        setSupportActionBar(findViewById(R.id.toolbar))

        findViewById<View>(R.id.fab).setOnClickListener { view ->
            Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                .setAction("Action", null).show()
        }

        val avifDecoder = AvifDecoder.fromByteArray(inputStreamToBytes(assets.open("test.avif"))).apply { nextImage() }
        findViewById<ImageView>(R.id.avif_img).setImageBitmap(avifDecoder.frame)
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        // Inflate the menu; this adds items to the action bar if it is present.
        menuInflater.inflate(R.menu.menu_main, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        return when (item.itemId) {
            R.id.action_settings -> true
            else -> super.onOptionsItemSelected(item)
        }
    }

    private fun inputStreamToBytes(`is`: InputStream): ByteArray? {
        val buffer = ByteArrayOutputStream(64 * 1024)
        try {
            var nRead: Int
            val data = ByteArray(16 * 1024)
            while (`is`.read(data).also { nRead = it } != -1) {
                buffer.write(data, 0, nRead)
            }
            buffer.close()
        } catch (e: IOException) {
            return null
        }
        return buffer.toByteArray()
    }
}