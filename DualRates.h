#ifndef INC_TX_DUALRATES_H
#define INC_TX_DUALRATES_H

/* ---------------------------------------------------------------------------
** This software is in the public domain, furnished "as is", without technical
** support, and with no warranty, express or implied, as to its usefulness for
** any purpose.
**
** DualRates.h
** Dual Rates functionality
**
** Author: Daniel van den Ouden
** Project: ArduinoRCLib
** Website: http://sourceforge.net/p/arduinorclib/
** -------------------------------------------------------------------------*/

#include <inttypes.h>


namespace tx {

/*! \brief Class to encapsulate Dual Rates functionality. Can be used as a plain uint8_t. */
class DualRates
{
public:
	/*! \brief Constructs a DualRates object
	    \param p_rate The rate to set, range [0 - 140].*/
	DualRates(uint8_t p_rate = 100);

	/*! \brief Copy constructor
	    \param p_rhs Object to copy with.*/
	DualRates(const DualRates& p_rhs);
	
	
	/*! \brief Sets the rate.
	    \param p_rate The rate to set, range [0 - 140].*/
	void set(uint8_t p_rate);
	
	/*! \brief Gets rate.
	    \return The current rate, range [0 - 140].*/
	uint8_t get() const;
	
	/*! \brief Copy assignment operator.
	    \param p_rhs Object to copy.
	    \return Reference to this object.*/
	DualRates& operator = (const DualRates& p_rhs);
	
	/*! \brief Assignment operator, sets rate.
	    \param p_rhs The rate to set, range [0 - 140].
	    \return Reference to this object.*/
	DualRates& operator = (uint8_t p_rhs);
	
	/*! \brief Cast operator, casts object to uint8_t.
	    \return Current rate, range [0 - 140].*/
	operator uint8_t () const;
	
	/*! \brief Reference operator, allow direct access to member through pointer for flexible get/set.
	    \return Pointer to rate.*/
	uint8_t* operator &();
	
	/*! \brief Reference operator, allow direct access to member through pointer for flexible get/set.
	    \return Pointer to rate.*/
	const uint8_t* operator &() const;
	
	/*! \brief Applies dual rates.
	    \param p_value Source value to apply d/r to, range [-256 - 256].
		\return d/r applied p_value, range 140% [-358 - 358].*/
	int16_t apply(int16_t p_value) const;
	
private:
	uint8_t m_rate;
};


} // namespace end

#endif // INC_TX_DUALRATES_H
