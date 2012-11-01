/* ---------------------------------------------------------------------------
** This software is in the public domain, furnished "as is", without technical
** support, and with no warranty, express or implied, as to its usefulness for
** any purpose.
**
** planemodel_example.pde
** Demonstrate PlaneModel functionality
**
** Author: Daniel van den Ouden
** Project: ArduinoRCLib
** Website: http://sourceforge.net/p/arduinorclib/
** Demonstration: https://www.youtube.com/watch?v=wCi2PpY_LIs
** -------------------------------------------------------------------------*/

#include <AIPin.h>
#include <Channel.h>
#include <DIPin.h>
#include <PlaneModel.h>
#include <ServoOut.h>
#include <Timer1.h>
#include <util.h>

#define SERVOS 5

uint8_t  g_pinsOut[SERVOS] = {2, 3, 4, 5, 6}; // Output pins
uint16_t g_input[SERVOS];                     // Input buffer for servoOut, microseconds
uint8_t  g_work[SERVOOUT_WORK_SIZE(SERVOS)];  // we need to have a work buffer for the ServoOut class

// ServoOut requires three buffers:
//     Pins buffer containing output pins
//     Input buffer containing input values in microseconds
//     Work buffer of SERVOOUT_WORK_SIZE(SERVOS) elements for internal calculations
// This setup removes any technical limit on the number of servos you want,
// and makes sure the library doesn't use more memory than it really needs,
// since the client code supplies the buffers.
rc::ServoOut g_ServoOut(g_pinsOut, g_input, g_work, SERVOS);

// The PlaneModel class supports quite a few types of airplane configurations
// We're gonna go with a rather simple setup:
// -2 aileron servos
// -1 flaps servo
// -1 elevator servo
// -1 rudder servo
rc::PlaneModel g_plane;

// We use a digital input pin as a switch for the flaps, you could also use an analog input
rc::DIPin g_flp(7);

// And we use three analog input pins for controls
rc::DIPin g_ail(A0);
rc::DIPin g_ele(A1);
rc::DIPin g_rud(A2);

// we can use some Channels here to set endpoints, or reverse actions
rc::Channel g_channels[SERVOS];

void setup()
{
	// Initialize the plane model
	g_plane.setWingType(rc::PlaneModel::WingType_Tailed); // we have a plane with a tail
	g_plane.setTailType(rc::PlaneModel::TailType_Normal); // single elevator, single rudder
	g_plane.setAileronCount(rc::PlaneModel::AileronCount_2); // dual aileron servos
	g_plane.setFlapCount(rc::PlaneModel::FlapCount_1); // single flap servo
	// since we're dealing with a pretty straightforward model, we don't have to set all sorts of mixes
	
	// PlaneModel will take aileron/elevator/rudder/flap/airbrake input and
	// calculate how the servos should move. Results are stored in the global
	// output buffer (in output.h) and can be accessed through rc::getOutput(index)
	// Consult PlaneModel.h to see which servos are used for each configuration.
	// The cool thing is that you can tell a Channel object to fetch its input
	// from the output buffer; you simply tell it which index to use.
	g_channels[0].setInput(rc::Output_AIL1); // First aileron servo
	g_channels[1].setInput(rc::Output_AIL2); // Second aileron servo
	g_channels[2].setInput(rc::Output_ELE1); // First (and in our case, only) elevator servo
	g_channels[3].setInput(rc::Output_RUD1); // First (and in our case, only) rudder servo
	g_channels[4].setInput(rc::Output_FLP1); // First (and in our case, only) flap servo
	// It's also possible to have multiple channels share the same rc::Output_XXXN,
	// each channel still has its own subtrim, endpoints and reverse settings.
	// For example you may have have multiple landing gear servos, they'll all share
	// the same input but you can still limit the throw of each servo by setting endpoints.
	// For available outputs, check output.h
	
	// Initialize timer1, this is required for all features that use Timer1
	// (PPMIn/PPMOut/ServoIn/ServoOut)
	rc::Timer1::init();
	
	// initialize the servo pins
	for (uint8_t i = 0;  i < SERVOS; ++i)
	{
		// set up output pins
		pinMode(g_pinsOut[i], OUTPUT);
		
		// put them low
		digitalWrite(g_pinsOut[i], LOW);
		
		// filll the input buffer with sane values
		g_input[0] = rc::normalizedToMicros(0);
	}
	
	g_ServoOut.start();
}

void loop()
{
	// Set a certain amount of flap if the flap switch is flicked, 0 otherwise
	int16_t flp = g_flp.read() ? 64 : 0;
	
	// Read input
	int16_t ail = g_ail.read();
	int16_t ele = g_ele.read();
	int16_t rud = g_rud.read();
	
	// apply input to the model
	g_plane.apply(ail, ele, rud, flp, 0); // we have no air brake, so just pass 0
	
	// That's all there's to it.
	// You can now get the values using rc::getOutput()
	// But because we've told our Channel objects where to find their input,
	// they will do that automagically when we call Channel::apply()
	// The channels will return normalized values (range -256 - 256) which need to 
	// be converted to microseconds before they're passed to the servos
	// same story if we'd want to generate a PPM signal instead of controlling servos directly
	for (uint8_t i = 0; i < SERVOS; ++i)
	{
		g_input[i] = rc::normalizedToMicros(g_channels[i].apply());
	}
	
	// we've filled the input buffer, now we can tell ServoOut that there are
	// new values available
	g_ServoOut.update();
}
