package com.example.rules

import android.util.Log
import androidx.compose.ui.test.ComposeTimeoutException
import androidx.compose.ui.test.isRoot
import androidx.compose.ui.test.junit4.ComposeTestRule
import androidx.compose.ui.test.printToLog
import org.junit.rules.TestWatcher
import org.junit.runner.Description

class DebugComposeErrorRule(private val composeTestRule: ComposeTestRule) : TestWatcher() {
    override fun failed(e: Throwable?, description: Description?) {
        Log.d("TRACE", "==== Beginning of trace ====")
        if (e is ComposeTimeoutException || e is AssertionError) {
            val onAllNodes = composeTestRule.onAllNodes(isRoot())
            onAllNodes.printToLog("TRACE")
            val size = onAllNodes.fetchSemanticsNodes().size
            for (i in 0 until size) {
                onAllNodes[i].printToLog("TRACE")
            }
        } else {
            Log.d("TRACE", "No trace available")
        }
    }
}
